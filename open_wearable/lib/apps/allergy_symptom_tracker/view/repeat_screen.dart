import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RepeatScreen extends StatelessWidget {
  final VoidCallback onRepeat;
  final VoidCallback onNext;
  final VoidCallback onLeaveStudy;
  final String stepHeading;
  final int repetition;
  final int maxRepetition;

  const RepeatScreen({
    super.key,
    required this.onRepeat,
    required this.onNext,
    required this.onLeaveStudy,
    required this.stepHeading,
    required this.repetition,
    required this.maxRepetition,
  });

  @override
  Widget build(BuildContext context) {
    const String repeatHeader = "Did the recording work correctly?";
    const String repeatText =
        "If something went wrong (e.g. sensors moved or you got distracted), please repeat the recording.";

    bool repetitionsLeft = repetition < maxRepetition;
    int nextRepetition = repetition + 1;
    String continueText = repetitionsLeft
        ? 'Next Step will be recoring $nextRepetition out of $maxRepetition for  $stepHeading.' //typo recoring -> recording
        : 'You have completed all recording steps for $stepHeading and the study will continue with the next symptom.';

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
      backgroundColor: WidgetStateProperty.all(Colors.grey),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    );

    // Rot für "Repeat"
    final ButtonStyle repeatButtonStyle = baseButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(Colors.redAccent),
      foregroundColor: WidgetStateProperty.all(Colors.white),
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
                      repeatHeader,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      repeatText,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      continueText,
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
