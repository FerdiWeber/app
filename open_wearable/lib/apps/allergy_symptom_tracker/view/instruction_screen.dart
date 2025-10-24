import 'package:flutter/material.dart';

class InstructionScreen extends StatelessWidget {
  final String heading;
  final String description;
  final String? pathToImage;
  final VoidCallback onNext;
  final VoidCallback onLeaveStudy;

  const InstructionScreen({
    super.key,
    required this.heading,
    required this.description,
    required this.onNext,
    required this.onLeaveStudy,
    this.pathToImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Überschrift (groß und fett)
              Text(
                heading,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Beschreibungstext (kleiner, grau)
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Optionales Bild
              if (pathToImage != null && pathToImage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Image.asset(
                    pathToImage!,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

              // 🔹 Weiter-Button
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Weiter",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 12), // Abstand

              ElevatedButton(
                onPressed: onLeaveStudy, // 👈 Neue Funktion verwenden
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Dunkelgrau
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Studie verlassen",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
