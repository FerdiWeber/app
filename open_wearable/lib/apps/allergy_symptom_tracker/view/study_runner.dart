import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/instruction_screen.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/measuring_screen.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/view/study_selection.dart';

class StudyRunner extends StatefulWidget {
  final StudyProtocol protocol;
  const StudyRunner({super.key, required this.protocol});

  @override
  State<StudyRunner> createState() => _StudyRunnerState();
}

class _StudyRunnerState extends State<StudyRunner> {
  late final List<StudyStep> _steps;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _steps = widget.protocol.getSteps();
  }

  void _nextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() => _currentIndex++);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Studie abgeschlossen"),
          content: const Text("Danke für die Teilnahme!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  platformPageRoute(
                    context: context,
                    builder: (_) => const StudySelection(),
                  ),
                  //TODO checken ob das noch passt, wenn Earables Selection erst noch kommen mus
                  (route) => route.isFirst, // nur bis zum App-Start-Screen löschen
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentIndex];

    if (step.type == StudyStepType.instruction) {
      return InstructionScreen(
        heading: step.heading,
        description: step.description,
        onNext: _nextStep,
      );
    } else {
      return MeasuringScreen(
        duration: step.duration,
        actionButton: step.actionButton,
        onNext: _nextStep,
        signalFrame: step.signalFrame,
        measuringTimes: step.measuringTimes,
      );
    }
  }
}
