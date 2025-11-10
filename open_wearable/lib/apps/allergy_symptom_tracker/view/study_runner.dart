import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
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

  // Zählt jetzt nur noch *erfolgreich abgeschlossene* Messungen
  int _measuringStepCounter = 0;

  bool _isConfirming = false;

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

    // Starte das Logging für diese Messung
    await _logger.startLogging(recordingId, false);

    // !!! DER SURVEY-BLOCK WIRD VON HIER ENTFERNT !!!

    _logger.logTaskStart(_currentIndex, step.heading, step.duration);

    // Konfiguriere und starte die Sensoren
    await _manager.setSensorLogFilePrefix(recordingId);
    await _manager.configureSensors();
    await _logger.sensorsReady; // Wartet auf erste Sync-Timestamps
    print("Sensoren sind konfiguriert und Aufnahme gestartet!");
  }

  // NEU: Stoppt Sensoren und geht zum Bestätigungs-Screen
  Future<void> _stopAndConfirm() async {
    // 1. Stoppe die Sensoren
    await _manager.deactivateSensors();
    print("Sensoren gestoppt, warte auf Bestätigung...");

    // 2. Setze den Flag, um den RepeatScreen anzuzeigen
    setState(() {
      _isConfirming = true;
    });
  }

  // NEU: Speichert Daten und geht zum nächsten Schritt
  Future<void> _saveAndAdvance() async {
    // 1. Log-Task beenden und Daten schreiben
    _logger.logTaskEnd();
    await _logger.stopAndWriteLogging(false);
    print("Aufnahme bestätigt und gespeichert!");

    // 2. Zurücksetzen, Zähler erhöhen und zum nächsten Schritt gehen
    setState(() {
      _isConfirming = false;
      _measuringStepCounter++; // Zähler wird HIER erhöht
      _nextStep(); // Geht zum nächsten _currentIndex
    });
  }

  // NEU: Verwirft Daten (implizit) und wiederholt den Schritt
  Future<void> _repeatMeasuringStep() async {
    print("Aufnahme wird verworfen und wiederholt...");
    // Daten werden implizit verworfen, da `stopAndWriteLogging` nie aufgerufen wurde.
    // Beim nächsten `_startMeasuring` wird die (nie geschriebene) Log-Session überschrieben.

    // Setze einfach den Flag zurück. Der build() zeigt jetzt wieder den
    // MeasuringScreen mit demselben _currentIndex und _measuringStepCounter.
    setState(() {
      _isConfirming = false;
    });
  }

  Future<void> _leaveStudy(bool needToSafe) async {
    // Stoppe die Sensoren (ohne die aktuellen Daten zu speichern)
    await _manager.deactivateSensors();

    if (needToSafe) {
      try {
        _logger.logTaskEnd();
        await _logger.stopAndWriteLogging(false);
        print("Letzte Log-Datei gespeichert (Abbruch).");
      } catch (e) {
        print("Fehler beim Speichern der Log-Datei beim Abbruch: $e");
      }
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

  // Diese Funktion wird jetzt nur noch für InstructionScreens
  // und von _saveAndAdvance aufgerufen.
  void _nextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() => _currentIndex++);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Studie completed"),
          content: const Text("Thank you for participating!"),
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
          // ... (unverändert) ...
          return PlatformScaffold(
            body: Center(
              child: PlatformCircularProgressIndicator(),
            ),
          );
        }

        // Fall 2: Fehler beim Laden (z.B. YAML nicht gefunden)
        if (snapshot.hasError) {
          // ... (unverändert) ...
          return PlatformScaffold(
            appBar: PlatformAppBar(title: Text("Fehler")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Fehler beim Laden der Konfiguration:\nStellen Sie sicher, dass '.../sensor_config.yaml' existiert und in pubspec.yaml registriert ist.\n\nFehlerdetails: ${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // NEU: Fall 3: Wir sind im Bestätigungs-Modus
        if (_isConfirming) {
          return RepeatScreen(
            onRepeat: _repeatMeasuringStep,
            onNext: _saveAndAdvance,
            onLeaveStudy: () => _leaveStudy(false),
          );
        }

        // Fall 4: Erfolgreich geladen, zeige die normale UI
        final step = _steps[_currentIndex];

        if (step.type == StudyStepType.instruction) {
          return InstructionScreen(
            heading: step.heading,
            description: step.description,
            onNext: _nextStep, // Instruction geht direkt weiter
            onLeaveStudy: () => _leaveStudy(false),
            pathToImage: step.pathToImage.isNotEmpty ? step.pathToImage : null,
            debugMode: step.debugMode,
          );
        } else {
          final date = DateTime.now().toIso8601String().replaceAll(':', '-');

          // Der _measuringStepCounter ändert sich jetzt erst NACH erfolgreicher Bestätigung.
          // Beim Wiederholen bleibt der Counter gleich, aber das Datum ändert sich,
          // was eine neue, eindeutige ID für den Wiederholungsversuch erstellt.
          final recordingId =
              "${widget.experimentId}_step${_measuringStepCounter + 1}_${step.heading.replaceAll(' ', '')}_$date";

          return MeasuringScreen(
            duration: step.duration,
            actionButton: step.actionButton,
            debugMode: step.debugMode,

            logger: _logger,
            recordingId: recordingId,
            stepHeading: step.heading, // Wird für das Logging-Event benötigt

            // Zeigt "Step 1", "Step 2" etc. basierend auf erfolgreichen Schritten
            measuringStepCounter: _measuringStepCounter + 1,

            onStart: () => _startMeasuring(recordingId),

            // GEÄNDERT: Ruft die neue Bestätigungs-Funktion auf
            onNext: _stopAndConfirm,

            onLeaveStudy: () => _leaveStudy(true),
            signalFrame: step.signalFrame,
            measuringTimes: step.measuringTimes,
            measuringInstructions: step.measuringInstructions,
            onActionButtonPressed: () {
              final currentStep = _steps[_currentIndex];
              _logger.logOtherEvent(
                // Zähler + 1, da er 0-basiert ist
                _measuringStepCounter + 1,
                currentStep.heading,
                currentStep.heading,
                "ActionButton_Pressed",
              );
            },
            onSignalFrameChanged: (bool isGreen) {
              final currentStep = _steps[_currentIndex];
              _logger.logOtherEvent(
                // Zähler + 1, da er 0-basiert ist
                _measuringStepCounter + 1,
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
