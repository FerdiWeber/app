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
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 1,
          practiceText: "you can now practice to swallow",
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
          duration: 25,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [3, 5],
          practiceText: "you can now practice to rub your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "rub your left eye",
            "Get ready to rub your right eye",
            "rub your right eye",
            "Get ready to rub both your eyey",
            "rub both your eyes",
          ],
          repetitions: 15,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 4,
          practiceText: "you can now practice to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: ["get ready to sniff", "now sniff"],
          repetitions: 10,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 4,
          practiceText: "you can now practice to to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: ["get ready to sniff", "now sniff"],
          repetitions: 10,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 4,
          practiceText: "you can now practice to to swallow",
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
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 10,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 4,
          practiceText: "you can now practice to to swallow",
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
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 10,
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
          duration: 31,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching yout palate",
          ],
          practiceText: "you can now practice to make the scratching movement",
          repetitions: 20,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "pumping movement",
          description: "try to pump salvia",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 31,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 20,
          practiceText: "you can now practice to do the pumping movement",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Reading",
          description: "From now on the study continues with everyday  tasks."
              "During the next step please behave normally and read the given text.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 300,
          actionButton: false,
          measuringInstructions: ["behave normally"],
          repetitions: 1,
        ),
      ];
}

class Dataset2Protocol extends StudyProtocol {
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
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 1,
          practiceText: "you can now practice to swallow",
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
          duration: 25,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [3, 5],
          practiceText: "you can now practice to rub your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "rub your left eye",
            "Get ready to rub your right eye",
            "rub your right eye",
            "Get ready to rub both your eyey",
            "rub both your eyes",
          ],
          repetitions: 15,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 31,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: ["get ready to sniff", "now sniff"],
          repetitions: 2,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 31,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: ["get ready to sniff", "now sniff"],
          repetitions: 2,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to to swallow",
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
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to to swallow",
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
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 2,
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
          duration: 31,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching yout palate",
          ],
          practiceText: "you can now practice to make the scratching movement",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "pumping movement",
          description: "try to pump salvia",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 35,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 2,
          practiceText: "you can now practice to do the pumping movement",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Reading",
          description: "From now on the study continues with everyday  tasks."
              "During the next step please behave normally and read the given text.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 300,
          actionButton: false,
          measuringInstructions: ["behave normally"],
          repetitions: 1,
        ),
      ];
}

class Dataset3Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          repetitions: 1,
          practiceText: "you can now practice to swallow",
          counterMode: true,
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description: "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time"
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 25,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [3, 5],
          practiceText: "you can now practice to rub your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "rub your left eye",
            "Get ready to rub your right eye",
            "rub your right eye",
            "Get ready to rub both your eyey",
            "rub both your eyes",
          ],
          repetitions: 15,
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: ["get ready to sniff", "now sniff"],
          repetitions: 2,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: ["get ready to sniff", "now sniff"],
          repetitions: 2,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Clearing the throat",
          description:
              "Clear your throat at regular intervals during the recording. "
              "Press the action button immediately at the beginning of clearing your throat.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press the action button immediately at the beginning of swallowing.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice to to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Clearing the throat",
          description:
              "Clear your throat at regular intervals during the recording. "
              "Press the action button immediately at the beginning of clearing your throat.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Scratching movement on the palate",
          description:
              "Use your tongue to make a scratching movement on the back of your palate. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 31,
          signalFrame: true,
          measuringTimes: [2, 5],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching yout palate",
          ],
          practiceText: "you can now practice to make the scratching movement",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "pumping movement",
          description: "try to pump salvia",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 35,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 2,
          practiceText: "you can now practice to do the pumping movement",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Reading",
          description: "From now on the study continues with everyday  tasks."
              "During the next step please behave normally and read the given text.",
          debugMode: true,
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 300,
          actionButton: false,
          measuringInstructions: ["behave normally"],
          repetitions: 1,
        ),
      ];
}
