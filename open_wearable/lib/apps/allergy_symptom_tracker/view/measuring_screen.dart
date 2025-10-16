import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class MeasuringScreen extends StatefulWidget {
  final int duration;
  final VoidCallback onNext;
  final bool actionButton;

  const MeasuringScreen({
    super.key,
    required this.duration,
    required this.onNext,
    required this.actionButton,
  });

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen> {
  late int _remaining;
  Timer? _timer;
  Timer? _preTimer;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  bool _showPreCountdown = true; // 👈 zeigt an, ob 3-2-1 Overlay aktiv ist
  int _preCount = 3;             // 👈 aktueller Wert des 3s-Countdowns

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

  // 🔹 Countdown vor der Messung
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

  // 🔹 Eigentliche Messung
  void _startMeasurementTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        _cancelAndNext();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _cancelAndNext() {
    _timer?.cancel();
    _preTimer?.cancel();
    _cameraController?.dispose();
    widget.onNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _preTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔹 Hauptinhalt (Kamera + Timer)
          Column(
            children: [
              // obere Hälfte: Kamera
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
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                    },
                  ),
                ),
              ),

              // untere Hälfte: Timer + Buttons
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Timer
                      Text(
                        '$_remaining s',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🟢 Optionaler Action-Button
                      if (widget.actionButton)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: hier gewünschte Aktion einbauen
                              debugPrint("Action button pressed!");
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.green, width: 3),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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

                      // 🔴 Skip/Cancel Button
                      ElevatedButton(
                        onPressed: _cancelAndNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),

          // Overlay for 3-2-1 Countdown
          if (_showPreCountdown)
            Container(
              color: Colors.black.withOpacity(0.7),
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
