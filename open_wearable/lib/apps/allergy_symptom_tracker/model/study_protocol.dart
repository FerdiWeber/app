import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_step.dart';

abstract class StudyProtocol {
  List<StudyStep> getSteps();
}

class Dataset1Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
    StudyStep(type: StudyStepType.instruction, heading: "Schlucken", description: "Schlucke während der Aufzeichnung so oft wie möglich. Betätige dabei bei bei jedem Schlucken den Action Button"),
    StudyStep(type: StudyStepType.measuring, duration: 30, actionButton: true),
    StudyStep(type: StudyStepType.instruction, heading: "Kratzbewegung am Gaumen", description: "Führe mit deiner Zugnge eine Kratzbewegung am hinteren Gaumen durch. Tue dies für 2 Sekunden und anschließend 5 sekunden nichts. Wiederhole das."),
    StudyStep(type: StudyStepType.measuring, duration: 30, signalFrame: true, measuringTimes: [2,3]),
    StudyStep(type: StudyStepType.instruction, heading: "Kratzbewegung an den Augen", description: "Krate/Reibe deine Augen mit deinen Händen \n Tue das für 2 Sekunden, und anschließend 5 Sekunden nicht. \n Wiederhole diese Schritte."),
    StudyStep(type: StudyStepType.measuring, duration: 30),
    StudyStep(type: StudyStepType.instruction, heading: "Husten", description: "Huste während der Aufzeichnung immer dann wenn der Rahmen des Bildschirmes Grün wird. Während der Rahmen rot ist, soll nichts getan werden"),
    StudyStep(type: StudyStepType.measuring, duration: 30, signalFrame: true, measuringTimes: [2,3]),
    StudyStep(type: StudyStepType.instruction, heading: "Kratzbewegung an den Ohren", description: "Wenn der Rahmen grün ist, soll mit den Händen an den Ohren gekratzt/gerieben werden. Sobald der Rahmen rot wird, soll nichts getan werden"),
    StudyStep(type: StudyStepType.measuring, duration: 30, signalFrame: true, measuringTimes: [2,3]),
    StudyStep(type: StudyStepType.instruction, heading: "Räuspern", description: "Räuspere dich in regelmäßigen Abständen. Bei jedem Räuspern soll der Action Button betätigt werden"),
    StudyStep(type: StudyStepType.measuring, duration: 30, actionButton: true),

  ];
}

class Dataset2Protocol extends StudyProtocol {
  @override
  List<StudyStep> getSteps() => [
    StudyStep(type: StudyStepType.instruction, heading: "Individuell", description: "Betätige während der Reaktion den Action Button. Stelle sicher, dass in der Measurement ID das gemessesne Sympton hinterlegt ist"),
    StudyStep(type: StudyStepType.measuring, duration: 60, actionButton: true),
  ];
}
