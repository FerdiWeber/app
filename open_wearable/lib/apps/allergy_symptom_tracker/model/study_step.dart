//to distinguishe different screens during the study

enum StudyStepType { instruction, measuring }

class StudyStep {
  final StudyStepType type;
  final String heading;
  final String pathToImage;
  final String description;
  final String practiceText;
  final int duration;
  final int repetitions;
  final bool actionButton;
  final bool signalFrame;
  final List<int> measuringTimes;
  final List<String> measuringInstructions;
  final bool debugMode;

  StudyStep({
    required this.type,
    this.heading = "",
    this.pathToImage = "",
    this.description = "",
    this.practiceText = "",
    this.duration = 0,
    this.repetitions = 1,
    this.actionButton = false,
    this.signalFrame = false,
    this.measuringTimes = const [0, 0],
    this.measuringInstructions = const [""],
    this.debugMode = false,
  });
}
