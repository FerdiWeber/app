import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';

abstract class StudyProtocol {
  List<StudyStep> getSteps();
}

class Dataset1Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Scratching movement on the palate",
          description:
              "Use your tongue to make a scratching movement on the back of your palate. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 34,
          signalFrame: true,
          measuringTimes: [2, 5],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description: "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time"
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 34,
          signalFrame: true,
          measuringTimes: [2, 5],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Coughing",
          description:
              "During the recording, try to cough at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Scratching movement at the ears",
          description: "Rub or scratch your ears with your hands. "
              "Make sure the headphones do not fall out of your ears while doing so. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 34,
          signalFrame: true,
          measuringTimes: [2, 5],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Clearing the throat",
          description:
              "Clear your throat at regular intervals during the recording. "
              "Press the action button immediately at the beginning of clearing your throat.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
        ),
      ];
}

class Dataset2Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
        StudyStep(
            type: StudyStepType.instruction,
            heading: "Individuell",
            description:
                "Betätige während der Reaktion den Action Button. Stelle sicher, dass in der Measurement ID das gemessesne Sympton hinterlegt ist"),
        StudyStep(
            type: StudyStepType.measuring, duration: 60, actionButton: true),
      ];
}
