//to distinguishe different screens during the study

enum StudyStepType {instruction, measuring}

class StudyStep {
  final StudyStepType type;
  final String description;
  final int duration; 

  StudyStep({
    required this.type,
    this.description = "",
    this.duration = 0,
  });
}
