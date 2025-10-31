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
        // 1. Die Haupt-Column füllt jetzt den ganzen Bildschirm
        child: Column(
          children: [
            // 2. Dieser 'Expanded'-Bereich nimmt allen freien Platz ein
            Expanded(
              child: Center(
                // 3. Der Inhalt wird *innerhalb* des freien Platzes zentriert
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24), // Etwas mehr Abstand

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Task:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            description,
                            // textAlign: TextAlign.center, // Entfernt
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 🔹 Optionales Bild (jetzt zentriert)
                    if (pathToImage != null && pathToImage!.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Image.asset(
                            pathToImage!,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 4. Die Buttons sind jetzt außerhalb von 'Expanded' und damit am Boden
            // 5. 'SizedBox' sorgt für die volle Breite
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 12), // Abstand

            // 5. 'SizedBox' sorgt für die volle Breite
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onLeaveStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Leave Study",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
