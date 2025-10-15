import 'package:flutter/material.dart';

class InstructionScreen extends StatelessWidget {
  final String text;
  final VoidCallback onNext;

  const InstructionScreen({super.key, required this.text, required this.onNext});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Center( // <--- das sorgt für echte vertikale Zentrierung
        child: Column(
          mainAxisSize: MainAxisSize.min, // verhindert Streckung
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onNext,
              child: const Text("Weiter"),
            ),
          ],
        ),
      ),
    ),
  );
}
}
