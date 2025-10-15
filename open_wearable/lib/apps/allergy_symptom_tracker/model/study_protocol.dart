import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';

abstract class StudyProtocol {
  List<StudyStep> getSteps();
}

class Dataset1Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
    StudyStep(type: StudyStepType.instruction, description: "Erste Task Set 1"),
    StudyStep(type: StudyStepType.measuring, duration: 30),
    StudyStep(type: StudyStepType.instruction, description: "Zweite Task Set 1"),
    StudyStep(type: StudyStepType.measuring, duration: 30),
    StudyStep(type: StudyStepType.instruction, description: "Dritte Task Set 1"),
    StudyStep(type: StudyStepType.measuring, duration: 30),
  ];
}

class Dataset2Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
    StudyStep(type: StudyStepType.instruction, description: "Erste Task Set 2"),
    StudyStep(type: StudyStepType.measuring, duration: 30),
  ];
}
