import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class MeasuringScreen extends StatefulWidget {
  final int duration;
  final VoidCallback onNext;
  final bool actionButton;
  final bool signalFrame;
  final List<int> measuringTimes;

  const MeasuringScreen({
    super.key,
    required this.duration,
    required this.onNext,
    required this.actionButton,
    required this.signalFrame,
    required this.measuringTimes,
  });

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen> {
  late int _remaining; // Gesamtdauer
  int _phaseRemaining = 0; // 🟢 Restzeit der aktuellen Farbphase

  Timer? _timer;
  Timer? _preTimer;
  Timer? _colorTimer;
  Timer? _phaseTimer; // 🟢 Neuer Timer für Phasen-Countdown

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

  void _startPreCountdown() {
    _preTimer = Timer.periodic(const Duration(seconds: 1), (t) {
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

    // 🟢 Wenn SignalFrame aktiv: kein Gesamttimer-Countdown, nur Duration-Begrenzung
    if (widget.signalFrame) {
      _startFrameCycle();

      // dieser Timer sorgt dafür, dass nach Ablauf der Gesamtdauer beendet wird
      _timer = Timer(Duration(seconds: widget.duration), _cancelAndNext);
    } else {
      // 🔴 Normaler Modus: Einfach runterzählen
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_remaining <= 1) {
          _cancelAndNext();
        } else {
          setState(() => _remaining--);
        }
      });
    }
  }

  // 🔹 Frame-Cycle für Signal-Modus
  void _startFrameCycle() {
    if (!widget.signalFrame || widget.measuringTimes.isEmpty) return;
    _cycleIndex = 0;
    _runNextPhase();
  }

  void _runNextPhase() async {
    bool nextIsGreen = _cycleIndex % 2 == 0;
    int phaseDuration =
        widget.measuringTimes[_cycleIndex % widget.measuringTimes.length];

    // 🟢 Start der neuen Farbphase
    setState(() {
      _isGreen = nextIsGreen;
      _showFrame = true;
      _phaseRemaining = phaseDuration;
    });

    // 🟢 Starte separaten Timer für den Phasen-Countdown
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

  void _cancelAndNext() {
    _timer?.cancel();
    _preTimer?.cancel();
    _colorTimer?.cancel();
    _phaseTimer?.cancel();
    _cameraController?.dispose();
    widget.onNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _preTimer?.cancel();
    _colorTimer?.cancel();
    _phaseTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Entscheide, welcher Timer angezeigt wird
    final int displayTime =
        widget.signalFrame ? _phaseRemaining : _remaining;

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
                              width: _cameraController!.value.previewSize!.height,
                              height: _cameraController!.value.previewSize!.width,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$displayTime s',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (widget.actionButton)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: OutlinedButton(
                            onPressed: () {
                              debugPrint("Action button pressed!");
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.green, width: 3,),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20,),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Action",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),

                      ElevatedButton(
                        onPressed: _cancelAndNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16,),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Skip",
                          style:
                              TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
