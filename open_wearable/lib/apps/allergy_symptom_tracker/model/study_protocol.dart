import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';

abstract class StudyProtocol {
  List<StudyStep> getSteps();
}

class Dataset1Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Schlucken",
          description:
              "Versuche während der Aufzeichnung in regelmäßigen Abständen zu schlucken. "
              "Betätige dabei unmittelbar zu Beginn des Schluckens den Action-Button.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          actionButton: true,
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Kratzbewegung am Gaumen",
          description:
              "Führe mit deiner Zunge eine Kratzbewegung am hinteren Gaumen aus. "
              "Bei dieser Aufzeichnung gibt es keinen Action-Button; der grüne Rahmen zeigt an, wann du die Aktion ausführen sollst. "
              "Führe die Aktion während der gesamten grünen Phase aus. "
              "Verhalte dich während der roten Phasen normal.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 4],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Kratzbewegung an den Augen",
          description: "Reibe oder kratze deine Augen mit den Händen. "
              "Bei dieser Aufzeichnung gibt es keinen Action-Button; der grüne Rahmen zeigt an, wann du die Aktion ausführen sollst. "
              "Führe die Aktion während der gesamten grünen Phase aus. "
              "Verhalte dich während der roten Phasen normal.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 4],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Husten",
          description: "In diesem Schritt sollst du husten. "
              "Bei dieser Aufzeichnung gibt es keinen Action-Button; der grüne Rahmen zeigt an, wann du die Aktion ausführen sollst. "
              "Führe die Aktion während der gesamten grünen Phase aus. "
              "Verhalte dich während der roten Phasen normal.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [1, 4],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Kratzbewegung an den Ohren",
          description: "Reibe oder kratze deine Ohren mit den Händen. "
              "Achte darauf, dass dabei die Kopfhörer nicht aus den Ohren fallen. "
              "Bei dieser Aufzeichnung gibt es keinen Action-Button; der grüne Rahmen zeigt an, wann du die Aktion ausführen sollst. "
              "Führe die Aktion während der gesamten grünen Phase aus. "
              "Verhalte dich während der roten Phasen normal.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 3],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Räuspern",
          description:
              "Räuspere dich in regelmäßigen Abständen während der Aufzeichnung. "
              "Betätige dabei unmittelbar zu Beginn des Räusperns den Action-Button.",
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
