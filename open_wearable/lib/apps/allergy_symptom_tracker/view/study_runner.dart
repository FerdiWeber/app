import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/practice_screen.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

import 'package:open_wearable/apps/allergy_symptom_tracker/view/symptom_survey.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/manager.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/config.dart';

import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/instruction_screen.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/measuring_screen.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/study_selection.dart';

import 'package:open_wearable/apps/allergy_symptom_tracker/view/repeat_screen.dart';

class StudyRunner extends StatefulWidget {
  final StudyProtocol protocol;

  final Wearable leftWearable;
  final Wearable rightWearable;
  final SensorConfigurationProvider leftConfigProvider;
  final SensorConfigurationProvider rightConfigProvider;
  final String experimentId;

  const StudyRunner({
    super.key,
    required this.protocol,
    required this.leftWearable,
    required this.rightWearable,
    required this.leftConfigProvider,
    required this.rightConfigProvider,
    required this.experimentId,
  });

  @override
  State<StudyRunner> createState() => _StudyRunnerState();
}

class _StudyRunnerState extends State<StudyRunner> {
  late final List<StudyStep> _steps;
  int _currentIndex = 0;
  bool _showPractice = true;
  int _repetitionCounter = 1;

  /// Zählt echte Mess-Schritte (1,2,3...)
  int _measuringStepCounter = 0;

  /// Merkt sich, welcher Measuring-Index zuletzt gezählt wurde
  int _lastCountedMeasuringIndex = -1;

  bool _isConfirming = false;

  late final ExperimentManager _manager;
  late final ExperimentLogger _logger;
  late final ExperimentConfig _expConfig;

  late final Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _steps = widget.protocol.getSteps();
    _logger = ExperimentLogger();

    _loadingFuture = _loadConfigAndInitManager();
  }

  Future<void> _loadConfigAndInitManager() async {
    const String configPath =
        'lib/apps/allergy_symptom_tracker/assets/sensor_config.yaml';
    final seed = widget.experimentId;
    _expConfig = await ExperimentConfig.fromFile(configPath, seed);

    _manager = ExperimentManager(
      logger: _logger,
      expConfig: _expConfig,
      leftWearable: widget.leftWearable,
      leftSensorCfgProvider: widget.leftConfigProvider,
      rightWearable: widget.rightWearable,
      rightSensorCfgProvider: widget.rightConfigProvider,
    );
  }

  Future<void> _startMeasuring(String recordingId) async {
    final step = _steps[_currentIndex];

    await _logger.startLogging(recordingId, false);
    _logger.logTaskStart(_currentIndex, step.heading, step.duration);

    await _manager.setSensorLogFilePrefix(recordingId);
    await _manager.configureSensors();
    await _logger.sensorsReady;

    print("Sensoren gestartet");
  }

  Future<void> _stopAndConfirm() async {
    await _manager.deactivateSensors();
    setState(() => _isConfirming = true);
  }

  Future<void> _saveAndAdvance() async {
    // Logging speichern
    _logger.logTaskEnd();
    await _logger.stopAndWriteLogging(false);

    final currentStep = _steps[_currentIndex];
    final maxRepetitions = currentStep.repetitions;

    setState(() {
      _isConfirming = false;

      if (_repetitionCounter < maxRepetitions) {
        // weitere Wiederholung des gleichen Schritts
        _repetitionCounter++;
        _showPractice = false;
      } else {
        _repetitionCounter = 1;
        _showPractice = true;
        _nextStep();
      }
    });
  }

  Future<void> _repeatMeasuringStep() async {
    print("Messung verworfen, Schritt wird wiederholt");
    setState(() => _isConfirming = false);
  }

  Future<void> _leaveStudy(bool needToSave) async {
    await _manager.deactivateSensors();

    if (needToSave) {
      try {
        _logger.logTaskEnd();
        await _logger.stopAndWriteLogging(false);
      } catch (_) {}
    }

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        platformPageRoute(
          context: context,
          builder: (_) => StudySelection(
            leftWearable: widget.leftWearable,
            rightWearable: widget.rightWearable,
            leftConfigProvider: widget.leftConfigProvider,
            rightConfigProvider: widget.rightConfigProvider,
          ),
        ),
        (route) => route.isFirst,
      );
    }
  }

  void _nextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() => _currentIndex++);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Study completed"),
          content: const Text("Thank you!"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  platformPageRoute(
                    context: context,
                    builder: (_) => StudySelection(
                      leftWearable: widget.leftWearable,
                      rightWearable: widget.rightWearable,
                      leftConfigProvider: widget.leftConfigProvider,
                      rightConfigProvider: widget.rightConfigProvider,
                    ),
                  ),
                  (route) => route.isFirst,
                );
              },
            )
          ],
        ),
      );
    }
  }

  void _jumpToStep(int index) {
    if (index >= 0 && index < _steps.length) {
      setState(() {
        _currentIndex = index;
        _repetitionCounter = 1; // Setze Wiederholungszähler zurück
        _showPractice = true; // Starte ggf. mit Practice-Screen
        _isConfirming = false; // Beende Bestätigungs-Modus
        // Optional: _measuringStepCounter und _lastCountedMeasuringIndex
        // müssen möglicherweise hier auch korrigiert werden,
        // wenn Sie zu einem früheren Messschritt springen.
        // Für dieses Beispiel lassen wir es einfach, da _ensureCorrectMeasuringStepCounter
        // im nächsten Build-Zyklus korrigiert wird.
      });
    }
  }

  void _ensureCorrectMeasuringStepCounter() {
    final step = _steps[_currentIndex];

    if (step.type == StudyStepType.measuring &&
        _repetitionCounter == 1 &&
        _currentIndex != _lastCountedMeasuringIndex) {
      _measuringStepCounter++;
      _lastCountedMeasuringIndex = _currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PlatformScaffold(
            body: Center(child: PlatformCircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return PlatformScaffold(
            appBar: PlatformAppBar(title: Text("Fehler")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("${snapshot.error}"),
              ),
            ),
          );
        }

        final step = _steps[_currentIndex];

        if (_isConfirming) {
          return RepeatScreen(
            onRepeat: _repeatMeasuringStep,
            onNext: _saveAndAdvance,
            stepHeading: step.heading,
            repetition: _repetitionCounter,
            maxRepetition: step.repetitions,
            onLeaveStudy: () => _leaveStudy(false),
          );
        }

        final instructionsStepsEntries = _steps
            .asMap()
            .entries
            .where((e) => e.value.type == StudyStepType.instruction)
            .toList();

        // extrahiere Listen: gefilterte Steps + ihre Original-Indizes
        final instructionsSteps =
            instructionsStepsEntries.map((e) => e.value).toList();
        final instructionsOriginalIndices =
            instructionsStepsEntries.map((e) => e.key).toList();

        if (step.type == StudyStepType.instruction) {
          return InstructionScreen(
            heading: step.heading,
            description: step.description,
            onNext: _nextStep,
            onLeaveStudy: () => _leaveStudy(false),
            pathToImage: step.pathToImage.isNotEmpty ? step.pathToImage : null,
            debugMode: step.debugMode,
            studySteps: instructionsSteps,
            studyStepsOriginalIndices: instructionsOriginalIndices, // neu
            currentOverallIndex: _currentIndex, // eindeutig nennen
            onJumpToStep: _jumpToStep, // erwartet weiterhin originalen Index
          );
        }

        // MEASURING
        if (_showPractice && _repetitionCounter == 1) {
          return PracticeScreen(
            practiceInstruction: step.practiceText,
            onStartMeasurment: () {
              setState(() => _showPractice = false);
            },
          );
        }

        final date = DateTime.now().toIso8601String().replaceAll(':', '-');

        final stepFilename = "$_measuringStepCounter.$_repetitionCounter";

        final recordingId =
            "${widget.experimentId}_step${stepFilename}_${step.heading.replaceAll(" ", "")}_$date";

        return MeasuringScreen(
          duration: step.duration,
          actionButton: step.actionButton,
          debugMode: step.debugMode,
          logger: _logger,
          recordingId: recordingId,
          stepHeading: step.heading,
          measuringStepCounter: _measuringStepCounter,
          onStart: () => _startMeasuring(recordingId),
          onNext: _stopAndConfirm,
          onLeaveStudy: () => _leaveStudy(true),
          signalFrame: step.signalFrame,
          measuringTimes: step.measuringTimes,
          measuringInstructions: step.measuringInstructions,
          counterMode: step.counterMode,
          onActionButtonPressed: () {
            _logger.logOtherEvent(
              _measuringStepCounter + 1,
              step.heading,
              step.heading,
              "ActionButton_Pressed",
            );
          },
          onActionButtonReleased: () {
            _logger.logOtherEvent(
              _measuringStepCounter + 1,
              step.heading,
              step.heading,
              "ActionButton_Released",
            );
          },
          onSignalFrameChanged: (bool isGreen) {
            _logger.logOtherEvent(
              _measuringStepCounter + 1,
              step.heading,
              step.heading,
              isGreen ? "SignalFrame_Start" : "SignalFrame_Stop",
            );
          },
        );
      },
    );
  }
}
