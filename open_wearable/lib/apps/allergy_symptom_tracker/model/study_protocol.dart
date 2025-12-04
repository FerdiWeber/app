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
              "Press and hold the action button during the entire time you are swallowing. \n"
              "Recording Type: Counter",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          counterMode: true,
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description:
              "For this step, ask the study coordinator to come and help you. "
              "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 83,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [
            5,
            5,
            3,
            5,
            4,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            4,
          ],
          practiceText: "You can now practice rubbing your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "Rub your left eye",
            "Get ready to rub your right eye",
            "Rub your right eye",
            "Get ready to rub both your eyes",
            "Rub both your eyes",
          ],
          repetitions: 2,
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description:
              "For this step, ask the study coordinator to come and help you. "
              "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 83,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [
            5,
            5,
            3,
            5,
            4,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            4,
          ],
          practiceText: "You can now practice rubbing your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "Rub your left eye",
            "Get ready to rub your right eye",
            "Rub your right eye",
            "Get ready to rub both your eyes",
            "Rub both your eyes",
          ],
          repetitions: 2,
        ),
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
          duration: 30,
          actionButton: true,
          repetitions: 4,
          practiceText: "you can now practice sniffing",
        ),
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
          duration: 62,
          signalFrame: true,
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 2, 5, 4, 5, 3, 5, 4],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching your palate",
          ],
          practiceText: "you can now practice the scratching movement",
          repetitions: 3,
        ),
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
          duration: 30,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat",
          repetitions: 4,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Cough",
          description: "Cough at regular intervals during the recording. "
              "Press and hold the action button during the entire time you are coughing. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Cough",
          practiceText: "you can now practice coughing",
          repetitions: 4,
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
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
          duration: 56,
          signalFrame: true,
          heading: "Rub on the ears",
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 5, 5, 4, 5, 3],
          practiceText: "you can now practice rubbing your ears.",
          measuringInstructions: [
            "Get ready to rub your left ear",
            "Rub your left ear",
            "Get ready to rub your right ear",
            "Rub your right ear",
            "Get ready to rub both your ears",
            "Rub both your ears",
          ],
          repetitions: 4,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Pumping movement",
          description: "Use your tongue to move saliva over your palate. "
              "The signal frame around the display indicates when you should perform the saliva movement. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 62,
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 2, 5, 4, 5, 3, 5, 4],
          measuringInstructions: [
            "get ready to for saliva movement",
            "keep performing the movement",
          ],
          repetitions: 3,
          practiceText: "you can now practice the saliva movement",
        ),
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
          duration: 30,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat",
          repetitions: 4,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Basic tasks",
          description: "You have now completed the first half of the study. "
              "In the second half you are going to do normal tasks, beginning with reading something, then watching and in the end eating something. "
              "Each of these tasks will last for 5 minutes. The signal frame and instructions on the display will lead you through the second half.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Basic tasks",
          duration: 927,
          signalFrame: true,
          measuringTimes: [5, 5, 300, 10, 300, 10, 300],
          measuringInstructions: [
            "get ready to read",
            "keep reading",
            "get ready to watch",
            "keep watching",
            "get ready to eat",
            "keep eating",
          ],
          repetitions: 1,
          practiceText: "start recording when you are prepared",
        ),
      ];
}

class Dataset2Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Basic tasks",
          description: "The study is divided in to two parts. "
              "In the first part you are going to do normal tasks, beginning with reading something, then watching and in the end eating something. "
              "Each of these tasks will last for 5 minutes. The signal frame and instructions on the display will lead you through the recording.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Basic tasks",
          duration: 927,
          signalFrame: true,
          measuringTimes: [5, 5, 300, 10, 300, 10, 300],
          measuringInstructions: [
            "get ready to read",
            "keep reading",
            "get ready to watch",
            "keep watching",
            "get ready to eat",
            "keep eating",
          ],
          repetitions: 1,
          practiceText:
              "Make sure everything is ready. By pressing the button, the recording will start.",
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description:
              "For this step, ask the study coordinator to come and help you. "
              "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 83,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [
            5,
            5,
            3,
            5,
            4,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            4,
          ],
          practiceText: "You can now practice rubbing your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "Rub your left eye",
            "Get ready to rub your right eye",
            "Rub your right eye",
            "Get ready to rub both your eyes",
            "Rub both your eyes",
          ],
          repetitions: 2,
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Rub on the eyes",
          description:
              "For this step, ask the study coordinator to come and help you. "
              "Rub your eyes with your hands. "
              "Try doing this once with only your right eye, once with only your left eye, and once with both eyes at the same time. "
              "In this recording, there is no action button; the green frame indicates when you should perform the action. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication ",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 83,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [
            5,
            5,
            3,
            5,
            4,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            4,
          ],
          practiceText: "You can now practice rubbing your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "Rub your left eye",
            "Get ready to rub your right eye",
            "Rub your right eye",
            "Get ready to rub both your eyes",
            "Rub both your eyes",
          ],
          repetitions: 2,
        ),
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
          duration: 30,
          actionButton: true,
          repetitions: 4,
          practiceText: "you can now practice sniffing",
        ),
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
          duration: 62,
          signalFrame: true,
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 2, 5, 4, 5, 3, 5, 4],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching your palate",
          ],
          practiceText: "you can now practice the scratching movement",
          repetitions: 3,
        ),
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
          duration: 30,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat clearing",
          repetitions: 4,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Cough",
          description: "Cough at regular intervals during the recording. "
              "Press and hold the action button during the entire time you are coughing. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Cough",
          practiceText: "you can now practice coughing",
          repetitions: 4,
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
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
          duration: 56,
          signalFrame: true,
          heading: "Rub on the ears",
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 5, 5, 4, 5, 3],
          practiceText: "you can now practice rubbing your ears.",
          measuringInstructions: [
            "Get ready to rub your left ear",
            "Rub your left ear",
            "Get ready to rub your right ear",
            "Rub your right ear",
            "Get ready to rub both your ears",
            "Rub both your ears",
          ],
          repetitions: 4,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Pumping movement",
          description: "Use your tongue to move saliva over your palate. "
              "The signal frame around the display indicates when you should perform the saliva movement. "
              "Perform the action throughout the entire green phase. "
              "Behave normally during the red phases. \n"
              "Recording Type: Frame indication",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "pumping movement",
          signalFrame: true,
          duration: 62,
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 2, 5, 4, 5, 3, 5, 4],
          measuringInstructions: [
            "get ready to for saliva movement",
            "keep performing the movement",
          ],
          repetitions: 3,
          practiceText: "you can now practice the saliva movement",
        ),
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
          duration: 30,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat clearing",
          repetitions: 4,
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
              "Press and hold the action button during the entire time you are swallowing. \n"
              "Recording Type: Counter",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Swallowing",
          duration: 10,
          actionButton: true,
          counterMode: true,
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
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
          duration: 83,
          signalFrame: true,
          heading: "Rub on the eyes",
          measuringTimes: [
            5,
            5,
            3,
            5,
            4,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            5,
            5,
            4,
            5,
            3,
            5,
            4,
          ],
          practiceText: "You can now practice rubbing your eyes",
          measuringInstructions: [
            "Get ready to rub your left eye",
            "Rub your left eye",
            "Get ready to rub your right eye",
            "Rub your right eye",
            "Get ready to rub both your eyes",
            "Rub both your eyes",
          ],
          repetitions: 2,
        ),
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
          duration: 30,
          actionButton: true,
          repetitions: 2,
          practiceText: "you can now practice sniffing",
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
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
          duration: 60,
          signalFrame: true,
          measuringTimes: [3, 5],
          measuringInstructions: [
            "Get ready to scratch your palate",
            "Keep scratching your palate",
          ],
          practiceText: "you can now practice the scratching movement",
          repetitions: 2,
        ),
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
          duration: 30,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat clearing",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Cough",
          description: "Cough at regular intervals during the recording. "
              "Press and hold the action button during the entire time you are coughing. \n"
              "Recording Type: Timer",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
          heading: "Cough",
          practiceText: "you can now practice coughing",
          repetitions: 2,
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
          repetitions: 2,
          practiceText: "You can now practice swallowing",
        ),
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
          duration: 56,
          signalFrame: true,
          heading: "Rub on the ears",
          measuringTimes: [5, 5, 4, 5, 3, 5, 4, 5, 5, 5, 4, 5, 3],
          practiceText: "you can now practice rubbing your ears.",
          measuringInstructions: [
            "Get ready to rub your left ear",
            "Rub your left ear",
            "Get ready to rub your right ear",
            "Rub your right ear",
            "Get ready to rub both your ears",
            "Rub both your ears",
          ],
          repetitions: 2,
        ),
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
          duration: 60,
          measuringTimes: [3, 5],
          measuringInstructions: ["get ready to pump", "keep pumping"],
          repetitions: 2,
          practiceText: "you can now practice the pumping movement",
        ),
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
          duration: 30,
          actionButton: true,
          heading: "Clearing the throat",
          practiceText: "you can now practice clearing your throat clearing",
          repetitions: 2,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Basic tasks",
          description: "You have now completed the first half of the study. "
              "In the second half you are going to do normal tasks, beginning with reading something, then watching and in the end eating something. "
              "Each of these tasks will last for 5 minutes. The signal frame and instructions on the display will lead you through the second half.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          heading: "Basic tasks",
          duration: 117,
          signalFrame: true,
          measuringTimes: [5, 5, 30, 10, 30, 10, 30],
          measuringInstructions: [
            "get ready to read",
            "keep reading",
            "get ready to watch",
            "keep watching",
            "get ready to eat",
            "keep eating",
          ],
          repetitions: 1,
          practiceText: "start recording when you are prepared",
        ),
      ];
}
