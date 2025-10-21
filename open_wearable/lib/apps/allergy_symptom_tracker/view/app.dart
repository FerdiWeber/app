import 'package:flutter/material.dart';
import 'package:open_wearable/apps/widgets/select_two_earable_view.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/study_selection.dart';

class AllergySymptomTrackerApp extends StatelessWidget {
  const AllergySymptomTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectTwoEarableView(
      startApp: (leftWearable, leftConfigProv, rightWearable, rightConfigProv) {
        // Diese Ansicht startet, nachdem die Kopfhörer ausgewählt wurden.
        return StudySelection(
          leftWearable: leftWearable,
          leftConfigProvider: leftConfigProv,
          rightWearable: rightWearable,
          rightConfigProvider: rightConfigProv,
        );
      },
    );
  }
}
