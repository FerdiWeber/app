import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

// Importiere deine neuen Manager- und Logger-Klassen
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/manager.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/config.dart'; // Du brauchst wahrscheinlich auch die Config

import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/instruction_screen.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/measuring_screen.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/study_selection.dart';

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
  int _measuringStepCounter = 0;

  // Instanzen für Manager und Logger
  late final ExperimentManager _manager;
  late final ExperimentLogger _logger;
  late final ExperimentConfig _expConfig; // Du musst eine Config laden oder erstellen

  @override
  void initState() {
    super.initState();
    _steps = widget.protocol.getSteps();
    _logger = ExperimentLogger();

    // Erstelle eine Dummy-Konfiguration. Idealerweise lädst du diese aus einer YAML-Datei.
    // Diese Konfiguration bestimmt, welche Sensoren mit welcher Rate aufnehmen.
    _expConfig = ExperimentConfig(
      blocks: [], // Nicht benötigt für diese Logik
      sensorIdMap: {},
      globalSensorConfigs: [
        SensorConfig(sensor: 'imu', sampleRate: 50),
        SensorConfig(sensor: 'pressure', sampleRate: 50),
        SensorConfig(sensor: 'microphone', sampleRate: 48000),
        SensorConfig(sensor: 'ppg', sampleRate: 50),
        SensorConfig(sensor: 'bone_conduction', sampleRate: 1600),
        SensorConfig(sensor: 'temperature', sampleRate: 8),
      ],
    );

    _manager = ExperimentManager(
      logger: _logger,
      expConfig: _expConfig,
      leftWearable: widget.leftWearable,
      leftSensorCfgProvider: widget.leftConfigProvider,
      rightWearable: widget.rightWearable,
      rightSensorCfgProvider: widget.rightConfigProvider,
    );
  }

  Future<void> _startMeasuring() async {
    setState(() {
      _measuringStepCounter++;
    });

    final step = _steps[_currentIndex];
    final date = DateTime.now().toIso8601String().replaceAll(':', '-');
    final recordingId = "${widget.experimentId}_step${_measuringStepCounter}_${step.heading.replaceAll(' ', '')}_$date";

    // Starte das Logging für diese Messung
    await _logger.startLogging(recordingId, false);
    _logger.logTaskStart(_currentIndex, step.heading, step.duration);

    // Konfiguriere und starte die Sensoren
    await _manager.setSensorLogFilePrefix(recordingId);
    await _manager.configureSensors();
    await _logger.sensorsReady; // Wartet auf erste Sync-Timestamps
    print("Sensoren sind konfiguriert und Aufnahme gestartet!");
  }

  Future<void> _stopMeasuring() async {
    // Stoppe die Sensoren und das Logging
    await _manager.deactivateSensors();
    _logger.logTaskEnd();
    await _logger.stopAndWriteLogging(false);
    print("Aufnahme gestoppt und gespeichert!");
  
    // Gehe zum nächsten Schritt
    _nextStep();
  }

  void _nextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() => _currentIndex++);
    } else {
      showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Studie abgeschlossen"),
      content: const Text("Danke für die Teilnahme!"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              platformPageRoute(
                context: context,
                // KORREKTUR: Übergebe die benötigten Parameter hier
                builder: (_) => StudySelection(
                  leftWearable: widget.leftWearable,
                  rightWearable: widget.rightWearable,
                  leftConfigProvider: widget.leftConfigProvider,
                  rightConfigProvider: widget.rightConfigProvider,
                ),
              ),
              // Dieser Teil löscht alle vorherigen Screens, was korrekt ist.
              (route) => route.isFirst,
            );
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
    }
  }

 @override
  Widget build(BuildContext context) {
    final step = _steps[_currentIndex];

    if (step.type == StudyStepType.instruction) {
      return InstructionScreen(
        heading: step.heading,
        description: step.description,
        onNext: _nextStep,
        pathToImage: step.pathToImage.isNotEmpty ? step.pathToImage : null,
      );
    } else {
      return MeasuringScreen(
        duration: step.duration,
        actionButton: step.actionButton,
        onStart: _startMeasuring, // Neue Callback-Funktion
        onNext: _stopMeasuring, // Stoppt die Messung
        signalFrame: step.signalFrame,
        measuringTimes: step.measuringTimes,

        onActionButtonPressed: () {
          final currentStep = _steps[_currentIndex];
          _logger.logOtherEvent(
            _measuringStepCounter,
            currentStep.heading,
            currentStep.heading,
            "ActionButton_Pressed",
          );
        },

        // Implementierung für den Signal Frame
        onSignalFrameChanged: (bool isGreen) {
          final currentStep = _steps[_currentIndex];
          _logger.logOtherEvent(
            _measuringStepCounter,
            currentStep.heading,
            currentStep.heading,
            isGreen ? "SignalFrame_Start" : "SignalFrame_Stop",
          );
        },
      );
    }
  }
}
