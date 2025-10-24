import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

// Importiere deine neuen Manager- und Logger-Klassen
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/manager.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/config.dart';

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
  late final ExperimentConfig _expConfig;

  late final Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _steps = widget.protocol.getSteps();
    _logger = ExperimentLogger();

    _loadingFuture = _loadConfigAndInitManager();
  }

  // Lädt die YAML und initialisiert den Manager
  Future<void> _loadConfigAndInitManager() async {
    // Pfad zur YAML-Datei (muss in pubspec.yaml registriert sein)
    const String configPath = 'lib/apps/allergy_symptom_tracker/assets/sensor_config.yaml';
    
    // "seed" wird in config.dart für die Randomisierung von Blöcken verwendet.
    // Wir verwenden hier die experimentId, um eine konsistente (aber pro ID einzigartige) Randomisierung zu erhalten.
    final seed = widget.experimentId; 

    _expConfig = await ExperimentConfig.fromFile(configPath, seed);

    // Initialisiere den Manager, SOBALD die Config geladen ist
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
    setState(() {
      _measuringStepCounter++;
    });

    final step = _steps[_currentIndex];
  
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
          child: const Text("OK"),
        ),
      ],
    ),
  );
    }
  }

 @override
  Widget build(BuildContext context) {
    // FutureBuilder wartet auf das Laden der Konfiguration
    return FutureBuilder<void>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        // Fall 1: Warten auf das Laden
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PlatformScaffold(
            body: Center(
              child: PlatformCircularProgressIndicator(),
            ),
          );
        }

        // Fall 2: Fehler beim Laden (z.B. YAML nicht gefunden)
        if (snapshot.hasError) {
          return PlatformScaffold(
            appBar: PlatformAppBar(title: Text("Fehler")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Fehler beim Laden der Konfiguration:\nStellen Sie sicher, dass '.../study_config.yaml' existiert und in pubspec.yaml registriert ist.\n\nFehlerdetails: ${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // Fall 3: Erfolgreich geladen, zeige die normale UI
        final step = _steps[_currentIndex];

        if (step.type == StudyStepType.instruction) {
          return InstructionScreen(
            heading: step.heading,
            description: step.description,
            onNext: _nextStep,
            pathToImage: step.pathToImage.isNotEmpty ? step.pathToImage : null,
          );
        } else {

          final date = DateTime.now().toIso8601String().replaceAll(':', '-');
          final recordingId =
              "${widget.experimentId}_step${_measuringStepCounter + 1}_${step.heading.replaceAll(' ', '')}_$date";

          return MeasuringScreen(
            duration: step.duration,
            actionButton: step.actionButton,

            logger: _logger,
            recordingId: recordingId,
            stepHeading: step.heading, // Wird für das Logging-Event benötigt
            measuringStepCounter: _measuringStepCounter + 1,

            onStart: () => _startMeasuring(recordingId),
            onNext: _stopMeasuring,
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
      },
    );
  }
}
