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
          description: "Schlucke während der Aufzeichnung so oft wie möglich. "
              "Drücke bei jedem Schlucken den Action-Button.",
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
              "Halte diese Bewegung für 2 Sekunden und mache dann 5 Sekunden Pause. "
              "Wiederhole diesen Ablauf während der gesamten Aufzeichnung.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 3],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Kratzbewegung an den Augen",
          description: "Reibe oder kratze deine Augen sanft mit den Händen, "
              "wenn der Rahmen grün ist. "
              "Während der roten Phase sollst du nichts tun. "
              "Wiederhole dies während der gesamten Messung.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 3],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Husten",
          description: "Huste immer dann, wenn der Rahmen grün ist. "
              "Während der roten Phase sollst du nicht husten.",
        ),
        StudyStep(
          type: StudyStepType.measuring,
          duration: 30,
          signalFrame: true,
          measuringTimes: [2, 3],
        ),
        StudyStep(
          type: StudyStepType.instruction,
          heading: "Kratzbewegung an den Ohren",
          description:
              "Wenn der Rahmen grün ist, kratze oder reibe mit den Händen an deinen Ohren. "
              "Sobald der Rahmen rot wird, mache eine Pause.",
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
          description: "Räuspere dich regelmäßig während der Aufzeichnung. "
              "Drücke bei jedem Räuspern den Action-Button.",
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
