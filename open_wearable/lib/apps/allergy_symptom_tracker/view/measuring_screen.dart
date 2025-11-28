import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MeasuringScreen extends StatefulWidget {
  final int duration;
  final VoidCallback onNext;
  final VoidCallback onStart;
  final VoidCallback onLeaveStudy;
  final bool actionButton;
  final bool signalFrame;
  final List<int> measuringTimes;
  final List<String> measuringInstructions;
  final bool counterMode;
  final bool debugMode;

  final ExperimentLogger logger;
  final String recordingId;
  final String stepHeading;
  final int measuringStepCounter;

  final VoidCallback? onActionButtonPressed;
  final VoidCallback? onActionButtonReleased;
  final Function(bool isGreen)? onSignalFrameChanged;

  const MeasuringScreen({
    super.key,
    required this.duration,
    required this.onNext,
    required this.onStart,
    required this.onLeaveStudy,
    required this.actionButton,
    required this.signalFrame,
    required this.measuringTimes,
    required this.measuringInstructions,
    required this.logger,
    required this.recordingId,
    required this.stepHeading,
    required this.measuringStepCounter,
    required this.counterMode,
    this.onActionButtonPressed,
    this.onActionButtonReleased,
    this.onSignalFrameChanged,
    this.debugMode = false,
  });

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen> {
  late int _remaining;
  int _phaseRemaining = 0;
  int _currentCount = 0;

  Timer? _timer;
  Timer? _preTimer;
  Timer? _colorTimer;
  Timer? _phaseTimer;

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  bool _showPreCountdown = true;
  bool _firstShowPreCountdown = true;
  int _preCount = 3;

  bool _isGreen = false;
  bool _showFrame = false;
  int _cycleIndex = 0;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _currentCount = 0;
    _initCamera();
    _startPreCountdown();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Kamera konnte nicht initialisiert werden: $e");
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint("Kamera nicht bereit für Aufnahme.");
      return;
    }

    try {
      await _cameraController!.startVideoRecording();

      widget.logger.logOtherEvent(
        widget.measuringStepCounter,
        widget.stepHeading,
        widget.stepHeading,
        "Video_Record_Start",
      );

      debugPrint("Videoaufnahme gestartet.");
    } catch (e) {
      debugPrint("Fehler beim Starten der Videoaufnahme: $e");
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();

      widget.logger.logOtherEvent(
        widget.measuringStepCounter,
        widget.stepHeading,
        widget.stepHeading,
        "Video_Record_Stop",
      );

      final directory = await getApplicationDocumentsDirectory();
      final String savePath =
          '${directory.path}/${widget.recordingId}_video.mp4';

      await videoFile.saveTo(savePath);
      debugPrint("Videoaufnahme gestoppt und gespeichert unter: $savePath");
    } catch (e) {
      debugPrint("Fehler beim Stoppen der Videoaufnahme: $e");
    }
  }

  void _startPreCountdown() {
    _preTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_preCount == 2) {
        widget.onStart();
        _startVideoRecording();
      }
      if (_preCount <= 1) {
        t.cancel();
        setState(() {
          _showPreCountdown = false;
        });
        _startMeasurementTimer();
      } else {
        setState(() => _preCount--);
      }
    });
  }

  void _startMeasurementTimer() {
    if (_firstShowPreCountdown) {
      setState(() => _firstShowPreCountdown = false);
    }

    if (widget.counterMode) {
      setState(() {});
    } else if (widget.signalFrame) {
      _startFrameCycle();
      _timer = Timer(Duration(seconds: widget.duration), _cancelAndNext);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_remaining <= 1) {
          _cancelAndNext();
        } else {
          setState(() => _remaining--);
        }
      });
    }
  }

  void _startFrameCycle() {
    if (!widget.signalFrame || widget.measuringTimes.isEmpty) return;
    _cycleIndex = widget.signalFrame ? 1 : 0;
    _runNextPhase();
  }

  void _runNextPhase() async {
    bool nextIsGreen = _cycleIndex % 2 == 0;
    int phaseDuration =
        widget.measuringTimes[_cycleIndex % widget.measuringTimes.length];

    setState(() {
      _isGreen = nextIsGreen;
      _showFrame = true;
      _phaseRemaining = phaseDuration;
    });

    widget.onSignalFrameChanged?.call(nextIsGreen);

    _phaseTimer?.cancel();
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_phaseRemaining <= 1) {
        t.cancel();
      }
      if (mounted) {
        setState(() => _phaseRemaining = (_phaseRemaining - 1).clamp(0, 9999));
      }
    });

    _colorTimer = Timer(Duration(seconds: phaseDuration), () {
      if (!mounted) return;
      _cycleIndex++;
      _runNextPhase();
    });
  }

  Future<void> _cancelAndNext() async {
    _timer?.cancel();
    _preTimer?.cancel();
    _colorTimer?.cancel();
    _phaseTimer?.cancel();
    await _stopVideoRecording();
    _cameraController?.dispose();
    widget.onNext();
  }

  void _cancelAndLeave() async {
    _timer?.cancel();
    _preTimer?.cancel();
    _colorTimer?.cancel();
    _phaseTimer?.cancel();

    await _stopVideoRecording();

    _cameraController?.dispose();

    widget.onLeaveStudy();
  }

  @override
  void dispose() {
    _stopVideoRecording();
    _timer?.cancel();
    _preTimer?.cancel();
    _colorTimer?.cancel();
    _phaseTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  void _onActionButtonPressed() {
    widget.onActionButtonPressed?.call();

    if (widget.counterMode) {
      setState(() {
        _currentCount++;
      });
    }
  }

  void _onActionButtonReleased() {
    widget.onActionButtonReleased?.call();

    if (widget.counterMode) {
      if (_currentCount >= widget.duration) {
        _cancelAndNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int displayTime = widget.signalFrame ? _phaseRemaining : _remaining;
    final int instructionIndex =
        (_cycleIndex - 1) % widget.measuringInstructions.length;
    final String currentInstruction =
        _showPreCountdown ? "" : widget.measuringInstructions[instructionIndex];
    String timerText;
    if (widget.counterMode) {
      timerText = '$_currentCount out of ${widget.duration}';
    } else {
      timerText = '$displayTime s';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              // Kamera
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          _cameraController != null &&
                          _cameraController!.value.isInitialized) {
                        return ClipRect(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  _cameraController!.value.previewSize!.height,
                              height:
                                  _cameraController!.value.previewSize!.width,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                    },
                  ),
                ),
              ),

              // Unterer Bereich: Timer + Buttons
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: widget.actionButton ? 0 : 110,
                              ),
                              child: Text(
                                currentInstruction,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text(
                                timerText,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- TEIL 2: Dein Action Button (fixiert positioniert) ---
                      if (widget.actionButton)
                        Align(
                          alignment: Alignment(0.0, 0.37),
                          child: SizedBox(
                            height: 230,
                            width: 350,
                            child: Listener(
                              onPointerDown: (_) {
                                _onActionButtonPressed();
                              },
                              onPointerUp: (_) {
                                _onActionButtonReleased();
                              },
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return Colors.green[900]!;
                                      }
                                      return Colors.green;
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return Colors.green;
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 20),
                                  ),
                                ),
                                child: const Text(
                                  "Action",
                                  style: TextStyle(
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // --- TEIL 3: Deine Debug-Buttons (fixiert unten) ---
                      if (widget.debugMode)
                        Positioned(
                          // 3. Positioniert die Debug-Buttons ganz unten
                          bottom: 20.0, // 20 Pixel Abstand vom Boden
                          left: 20.0, // 20 Pixel Abstand links
                          right: 20.0, // 20 Pixel Abstand rechts
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _cancelAndNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Skip",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _cancelAndLeave,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Leave Study",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),

          // Rahmenfarbe
          if (widget.signalFrame && _showFrame)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isGreen ? Colors.green : Colors.red,
                      width: 12,
                    ),
                  ),
                ),
              ),
            ),

          // 3..2..1 Overlay
          if (_showPreCountdown)
            Container(
              color: _firstShowPreCountdown
                  ? Colors.black.withOpacity(0.7)
                  : Colors.transparent,
              child: Center(
                child: Text(
                  '$_preCount',
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
