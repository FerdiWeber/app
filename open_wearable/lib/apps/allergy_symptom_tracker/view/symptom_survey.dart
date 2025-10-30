import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'study_runner.dart';

// Typ-Definition für die Ergebnisse, macht den Code lesbarer
typedef SurveyResults = Map<String, Map<String, int>>;

class SymptomSurveyScreen extends StatefulWidget {
  // Callback (onCompleted) wird ENTFERNT
  // final Function(SurveyResults) onCompleted;

  // NEU: Parameter für die Datenweitergabe
  final StudyProtocol protocol;
  final String experimentId;
  final Wearable leftWearable;
  final Wearable rightWearable;
  final SensorConfigurationProvider leftConfigProvider;
  final SensorConfigurationProvider rightConfigProvider;

  const SymptomSurveyScreen({
    super.key,
    // required this.onCompleted, // ENTFERNT
    // NEU: Konstruktor-Parameter
    required this.protocol,
    required this.experimentId,
    required this.leftWearable,
    required this.rightWearable,
    required this.leftConfigProvider,
    required this.rightConfigProvider,
  });

  @override
  State<SymptomSurveyScreen> createState() => _SymptomSurveyScreenState();
}

class _SymptomSurveyScreenState extends State<SymptomSurveyScreen> {
  // Liste der Symptome, die abgefragt werden sollen
  // Passe diese Liste nach deinen Bedürfnissen an
  final List<String> _symptoms = [
    'Husten',
    'Räuspern',
    'Niesen',
    'Juckende Augen',
    'Laufende Nase'
  ];

  // Map zur Speicherung der Antworten
  // Struktur: { 'Husten': { 'familiar': 1, 'frequent': 3 }, ... }
  late final Map<String, Map<String, int?>> _answers;

  @override
  void initState() {
    super.initState();
    // Initialisiere die Antwort-Map mit 'null' für jedes Symptom und jede Frage
    _answers = {
      for (var symptom in _symptoms)
        symptom: {
          'familiar': null,
          'frequent': null,
        }
    };
  }

  // Prüft, ob alle Fragen beantwortet wurden
  bool _isSurveyComplete() {
    for (var symptom in _symptoms) {
      if (_answers[symptom]!['familiar'] == null ||
          _answers[symptom]!['frequent'] == null) {
        return false; // Mindestens eine Antwort fehlt
      }
    }
    return true; // Alle Antworten sind vorhanden
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom-Umfrage'),
      ),
      body: Column(
        children: [
          Expanded(
            // ListView stellt die Scrollbarkeit sicher
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              // Die Anzahl der Symptome + 1 Platz für den "Weiter"-Button
              itemCount: _symptoms.length,
              itemBuilder: (context, index) {
                final symptom = _symptoms[index];
                return _buildSymptomCard(symptom);
              },
            ),
          ),
          // Der "Weiter"-Button am unteren Rand
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              // Der Button ist nur klickbar, wenn die Umfrage komplett ist
              onPressed: _isSurveyComplete()
                  ? () {
                      // 1. Wandle die Map in eine nicht-nullable Version um
                      final results = _answers.map((symptom, questions) {
                        return MapEntry(symptom, questions.map((key, value) {
                          return MapEntry(key,
                              value!); // value! ist sicher dank _isSurveyComplete
                        }));
                      });

                      // 2. ALT: widget.onCompleted(results); // ENTFERNT

                      // 3. NEU: Navigiere zum StudyRunner und ersetze
                      //    diesen Screen
                      Navigator.pushReplacement(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (_) => StudyRunner(
                            // 4. Reiche ALLE Daten weiter
                            protocol: widget.protocol,
                            experimentId: widget.experimentId,
                            leftWearable: widget.leftWearable,
                            rightWearable: widget.rightWearable,
                            leftConfigProvider: widget.leftConfigProvider,
                            rightConfigProvider: widget.rightConfigProvider,
                            // 5. Füge die Survey-Ergebnisse hinzu
                            surveyResults: results,
                          ),
                        ),
                      );
                    }
                  : null, // Deaktiviert den Button, wenn 'null'
              child: const Text('Weiter'),
            ),
          ),
        ],
      ),
    );
  }

  // Baut eine einzelne "Karte" für ein Symptom
  Widget _buildSymptomCard(String symptom) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symptom,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildQuestion(
              question: 'Wie vertraut ist Ihnen dieses Symptom?',
              symptom: symptom,
              questionKey: 'familiar',
              labels: ['Gar nicht', 'Sehr'],
            ),
            const SizedBox(height: 24),
            _buildQuestion(
              question: 'Wie häufig tritt dieses Symptom bei Ihnen auf?',
              symptom: symptom,
              questionKey: 'frequent',
              labels: ['Nie', 'Sehr oft'],
            ),
          ],
        ),
      ),
    );
  }

  // Baut eine einzelne Frage mit der 5-stufigen Skala
  // In open_wearable/lib/apps/allergy_symptom_tracker/view/symptom_survey_screen.dart

  // Baut eine einzelne Frage mit der 5-stufigen Skala
  Widget _buildQuestion({
    required String question,
    required String symptom,
    required String questionKey,
    required List<String> labels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: List.generate(5, (i) => i + 1).map((value) {
            return ButtonSegment<int>(
              value: value,
              label: Text(value.toString()),
            );
          }).toList(),
          selected: {_answers[symptom]![questionKey]}.whereType<int>().toSet(),
          multiSelectionEnabled: false,
          showSelectedIcon: false,

          // ÄNDERUNG 1: Erlaube dem Button, mit einer leeren Auswahl zu starten.
          emptySelectionAllowed: true,

          onSelectionChanged: (Set<int> newSelection) {
            setState(() {
              // ÄNDERUNG 2: Behandle den Fall, dass die Auswahl aufgehoben wird
              // (newSelection ist dann leer).
              _answers[symptom]![questionKey] =
                  newSelection.isEmpty ? null : newSelection.first;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(labels[0], style: Theme.of(context).textTheme.bodySmall),
              Text(labels[1], style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        )
      ],
    );
  }
}
