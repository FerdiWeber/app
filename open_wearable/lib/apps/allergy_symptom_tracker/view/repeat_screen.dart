import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RepeatScreen extends StatelessWidget {
  final VoidCallback onRepeat;
  final VoidCallback onNext;
  final VoidCallback onLeaveStudy;

  const RepeatScreen({
    super.key,
    required this.onRepeat,
    required this.onNext,
    required this.onLeaveStudy,
  });

  @override
  Widget build(BuildContext context) {
    // Gemeinsamer Stil für beide Buttons
    final ButtonStyle baseButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 18),
    );

    // Grau für "Next Step"
    final ButtonStyle nextButtonStyle = baseButtonStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    );

    // Rot für "Repeat"
    final ButtonStyle repeatButtonStyle = baseButtonStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.redAccent),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    );

    return PlatformScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Haupttext in der Mitte
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // linksbündig
                  children: [
                    Text(
                      "Did the recording work correctly?",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "If something went wrong (e.g., you coughed, sensors moved, or you got distracted), please repeat the recording.",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons unten
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔁 Repeat Button (oben)
                PlatformElevatedButton(
                  onPressed: onRepeat,
                  material: (_, __) => MaterialElevatedButtonData(
                    style: repeatButtonStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.repeat, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Repeat Recording"),
                      ],
                    ),
                  ),
                  cupertino: (_, __) => CupertinoElevatedButtonData(
                    color: Colors.redAccent,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    borderRadius: BorderRadius.circular(12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.repeat, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Repeat Recording",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  child: const SizedBox(),
                ),

                const SizedBox(height: 12),

                // "Next Step" Button (unten)
                PlatformElevatedButton(
                  onPressed: onNext,
                  material: (_, __) => MaterialElevatedButtonData(
                    style: nextButtonStyle,
                    child: const Text("Next Step"),
                  ),
                  cupertino: (_, __) => CupertinoElevatedButtonData(
                    color: Colors.grey,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    borderRadius: BorderRadius.circular(12),
                    child: const Text(
                      "Next Step",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  child: const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
