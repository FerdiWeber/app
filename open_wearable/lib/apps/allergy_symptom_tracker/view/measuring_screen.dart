import 'dart:async';

import 'package:flutter/material.dart';


class MeasuringScreen extends StatefulWidget {
  final int duration;
  final VoidCallback onNext;

  const MeasuringScreen({super.key, required this.duration, required this.onNext});

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen> {
  late int _remaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
        widget.onNext();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 2/3 Kamera-Vorschau
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text("Kamera-Vorschau hier", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          // 1/3 Timer
          Expanded(
            flex: 1,
            child: Center(
              child: Text("$_remaining s", style: const TextStyle(fontSize: 40)),
            ),
          ),
        ],
      ),
    );
  }
}
