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
              "During the recording, try to swallow at regular intervals."
              "Press and hold the action button during the whole time of you swallowing. \n"
              "Recording Type: Counter",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          counterMode: true,
          repetitions: 5,
          practiceText: "you can now practice to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description: "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time"
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 25,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [3, 5, 4, 5, 3, 5, 4, 5],
          practiceText: "you can now practice to rub your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "rub your left eye",
            "Get ready to rub your right eye",
            "rub your right eye",
            "Get ready to rub both your eyey",
            "rub both your eyes",
          ],
          repetitions: 5,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals."
              "Press and hold the action button during the whole time of you swallowing. \n"
              "Recording Type: Counter",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          counterMode: true,
          repetitions: 5,
          practiceText: "you can now practice to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals."
              "Press and hold the action button during the whole time of you swallowing. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 30,
          actionButton: true,
          repetitions: 5,
          practiceText: "you can now practice to to sniff",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Scratching movement on the palate",
          description:
              "Use your tongue to make a scratching movement on the back of your palate. "
              "The Signal Frame around the display indicates when you should do your scratching movement."
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 60,
          signalFrame: true,
          measuringTimes: [3, 5],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching yout palate",
          ],
          practiceText: "you can now practice to make the scratching movement",
          repetitions: 5,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Clearing the throat",
          description:
              "Clear your throat at regular intervals during the recording."
              "Press and hold the action button during the whole time of your clearing your throat. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 5,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Cough",
          description: "Cough at regular intervals during the recording."
              "Press and hold the action button during the whole time of your cough \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Cough",
          practiceText: "you can now practice to cough",
          repetitions: 5,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals."
              "Press and hold the action button during the whole time of you swallowing. \n"
              "Recording Type: Counter",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          counterMode: true,
          repetitions: 5,
          practiceText: "you can now practice to swallow",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the ears",
          description: "Rub your ears with your hands."
              "Try to to this once only with your left ear, once with your right ear, an one wit both ears at the same time."
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 25,
          signalFrame: true,
          heading: "Rub on the ears",
          measuringTimes: [3, 5, 4, 5, 3, 5, 4, 5],
          practiceText: "you can now practice to rub your ears.",
          measuringInstructions: [
            "Get ready to rub your left ear",
            "rub your left ear",
            "Get ready to rub your right ear",
            "rub your right ear",
            "Get ready to rub both your ear",
            "rub both your ear",
          ],
          repetitions: 5,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "pumping movement",
          description: "Use your tongue to move salvia over your palate. "
              "The Signal Frame around the display indicates when you should do your pumping movement."
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 60,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 5,
          practiceText: "you can now practice to do the pumping movement",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Clearing the throat",
          description:
              "Clear your throat at regular intervals during the recording."
              "Press and hold the action button during the whole time of your clearing your throat. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Clearing the throad",
          practiceText: "you can now practice to do some throath clearing",
          repetitions: 5,
        ),
      ];
}

class Dataset2Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Pumping movement",
          description: "Use your tongue to move saliva over your palate. "
              "The signal frame around the display indicates when you should perform the pumping movement. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 10,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 1,
          practiceText: "you can now practice the pumping movement",
        ),

        StudyStep(
          type: StudyStepType.instruction,
          heading: "Swallowing",
          description:
              "During the recording, try to swallow at regular intervals. "
              "Press and hold the action button during the entire time you are swallowing. \n"
              "Recording Type: Counter",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          counterMode: true,
          repetitions: 1,
          practiceText: "You can now practice swallowing",
        ),
        //eyes
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description: "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 10,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [3, 5, 4, 5, 3, 5, 4, 5],
          practiceText: "You can now practice rubbing your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "Rub your left eye",
            "Get ready to rub your right eye",
            "Rub your right eye",
            "Get ready to rub both your eyes",
            "Rub both your eyes",
          ],
          repetitions: 1,
        ),

//sniff
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Sniffing",
          description:
              "During the recording, try to sniff at regular intervals. "
              "Press and hold the action button during the entire time you are sniffing. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Sniffing",
          duration: 10,
          actionButton: true,
          repetitions: 1,
          practiceText: "you can now practice sniffing",
        ),

//throath Clearing
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Clearing the throat",
          description:
              "Clear your throat at regular intervals during the recording. "
              "Press and hold the action button during the entire time you are clearing your throat. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 10,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat clearing",
          repetitions: 1,
        ),

//palate Scratching
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Scratching movement on the palate",
          description:
              "Use your tongue to make a scratching movement on the back of your palate. "
              "The signal frame around the display indicates when you should perform the movement."
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 10,
          signalFrame: true,
          measuringTimes: [3, 5],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching your palate",
          ],
          practiceText: "you can now practice the scratching movement",
          repetitions: 1,
        ),

//salvia pumping
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Pumping movement",
          description: "Use your tongue to move saliva over your palate. "
              "The signal frame around the display indicates when you should perform the pumping movement. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 10,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 1,
          practiceText: "you can now practice the pumping movement",
        ),

//ears rub
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the ears",
          description: "Rub your ears with your hands. "
              "Try to do this once with only your left ear, once with only your right ear, and once with both ears at the same time. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 10,
          signalFrame: true,
          heading: "Rub on the ears",
          measuringTimes: [3, 5, 4, 5, 3, 5, 4, 5],
          practiceText: "you can now practice rubbing your ears.",
          measuringInstructions: [
            "Get ready to rub your left ear",
            "Rub your left ear",
            "Get ready to rub your right ear",
            "Rub your right ear",
            "Get ready to rub both your ear",
            "Rub both your ear",
          ],
          repetitions: 1,
        ),

//Cough
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Cough",
          description: "Cough at regular intervals during the recording. "
              "Press and hold the action button during the entire time you are coughing. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 10,
          actionButton: true,
          heading: "Cough",
          practiceText: "you can now practice coughing",
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
