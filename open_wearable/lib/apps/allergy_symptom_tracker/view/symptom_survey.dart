import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'study_runner.dart';

// Typ-Definition für die Ergebnisse.
// Passt immer noch:
// 'general' -> {'hadHayFever': 1}
// 'Cough' -> {'familiarity': 3, 'frequency': 2}
typedef SurveyResults = Map<String, Map<String, int>>;

class SymptomSurveyScreen extends StatefulWidget {
  // Alle Parameter, die vom ExplanationScreen durchgereicht werden
  final StudyProtocol protocol;
  final String experimentId;
  final Wearable leftWearable;
  final Wearable rightWearable;
  final SensorConfigurationProvider leftConfigProvider;
  final SensorConfigurationProvider rightConfigProvider;

  const SymptomSurveyScreen({
    Key? key,
    required this.protocol,
    required this.experimentId,
    required this.leftWearable,
    required this.rightWearable,
    required this.leftConfigProvider,
    required this.rightConfigProvider,
  }) : super(key: key);

  @override
  State<SymptomSurveyScreen> createState() => _SymptomSurveyScreenState();
}

class _SymptomSurveyScreenState extends State<SymptomSurveyScreen> {
  bool? _hadHayFever;

  final List<String> _symptoms = [
    'Globus sensation',
    'Itchy palate',
    'Itchy eyes',
    'Cough',
    'Itchy ears',
    'Frequent throat clearing',
  ];

  // Map zur Speicherung der Antworten
  // Struktur: { 'Cough': { 'familiarity': 1, 'frequency': 3 }, ... }
  late final Map<String, Map<String, int?>> _answers;

  @override
  void initState() {
    super.initState();
    // Initialisiere die Antwort-Map mit 'null' für jedes Symptom
    _answers = {
      for (var symptom in _symptoms)
        symptom: {
          'familiarity': null, // NEUER KEY
          'frequency': null, // NEUER KEY
        }
    };
  }

  // Prüft, ob ALLE Fragen (auch die allgemeine) beantwortet wurden
  bool _isSurveyComplete() {
    // 1. Prüfe die allgemeine Frage
    if (_hadHayFever == null) {
      return false;
    }

    // 2. Prüfe alle Symptom-Fragen
    for (var symptom in _symptoms) {
      if (_answers[symptom]!['familiarity'] == null ||
          _answers[symptom]!['frequency'] == null) {
        return false; // Mindestens eine Antwort fehlt
      }
    }
    return true; // Alle Antworten sind vorhanden
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Survey'),
        // Hier ist der "Zurück"-Pfeil (wie zuletzt besprochen)
        // Er wird automatisch angezeigt, da wir 'automaticallyImplyLeading: false' entfernt haben.
      ),
      body: Column(
        children: [
          Expanded(
            // ListView stellt die Scrollbarkeit sicher
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              // Die Anzahl der Symptome + 1 Platz für die allgemeine Frage
              itemCount: _symptoms.length + 1,
              itemBuilder: (context, index) {
                // NEU: Der erste Eintrag (index 0) ist die allgemeine Frage
                if (index == 0) {
                  return _buildHayFeverCard();
                }
                // Alle folgenden Einträge sind die Symptom-Karten
                final symptom = _symptoms[index - 1];
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
                      // 1. Wandle die Symptom-Antworten um
                      final SurveyResults results =
                          _answers.map((symptom, questions) {
                        return MapEntry(symptom, questions.map((key, value) {
                          return MapEntry(key,
                              value!); // value! ist sicher dank _isSurveyComplete
                        }));
                      });

                      // 2. NEU: Füge die allgemeine Frage zu den Ergebnissen hinzu
                      // (Wir kodieren bool als int, um dem 'SurveyResults'-Typ zu entsprechen)
                      results['general'] = {
                        'hadHayFever': _hadHayFever! ? 1 : 0
                      };

                      // 3. Navigiere zum StudyRunner und übergebe ALLE Daten
                      Navigator.pushReplacement(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (_) => StudyRunner(
                            // Daten aus dem Survey-Konstruktor
                            protocol: widget.protocol,
                            experimentId: widget.experimentId,
                            leftWearable: widget.leftWearable,
                            rightWearable: widget.rightWearable,
                            leftConfigProvider: widget.leftConfigProvider,
                            rightConfigProvider: widget.rightConfigProvider,
                            // Die gesammelten Ergebnisse
                            surveyResults: results,
                          ),
                        ),
                      );
                    }
                  : null, // Deaktiviert den Button, wenn 'null'
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  // NEU: Eine eigene Karte für die allgemeine Ja/Nein-Frage
  Widget _buildHayFeverCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Question',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Have you ever had hay fever?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Yes'),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('No'),
                ),
              ],
              selected: _hadHayFever == null ? {} : {_hadHayFever!},
              multiSelectionEnabled: false,
              showSelectedIcon: false,
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  // Erlaube das Leeren nicht, aber 'firstOrNull' fängt es sicher ab
                  if (newSelection.isNotEmpty) {
                    _hadHayFever = newSelection.first;
                  }
                });
              },
            ),
          ],
        ),
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
            // FRAGE 1: Familiarity
            _buildQuestion(
              question: 'Level of Familiarity',
              symptom: symptom,
              questionKey: 'familiarity',
              // 5-Punkte-Skala
              numSegments: 5,
              // End-Labels für die 4-Punkte-Skala
              labels: ['Not at all familiar', 'Extremely familiar'],
            ),
            const SizedBox(height: 24),
            // FRAGE 2: Frequency
            _buildQuestion(
              question: 'Frequency',
              symptom: symptom,
              questionKey: 'frequency',
              // 5-Punkte-Skala
              numSegments: 5,
              // End-Labels für die 5-Punkte-Skala
              labels: ['Never', 'A great deal'],
            ),
          ],
        ),
      ),
    );
  }

  // Baut eine einzelne Frage mit einer N-stufigen Skala
  Widget _buildQuestion({
    required String question,
    required String symptom,
    required String questionKey,
    required int numSegments, // NEU: 4 für Q1, 5 für Q2
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
          // Erzeugt Segmente [1, 2, 3, 4] oder [1, 2, 3, 4, 5]
          segments: List.generate(numSegments, (i) => i + 1).map((value) {
            return ButtonSegment<int>(
              value: value,
              label: Text(value.toString()),
            );
          }).toList(),
          // Holt den aktuell gespeicherten Wert (z.B. 3)
          selected: {_answers[symptom]![questionKey]}.whereType<int>().toSet(),
          multiSelectionEnabled: false,
          showSelectedIcon: false,
          emptySelectionAllowed: true, // Erlaubt das "Leeren" der Auswahl

          onSelectionChanged: (Set<int> newSelection) {
            setState(() {
              // Speichert 'null', wenn die Auswahl geleert wird,
              // ansonsten den ersten Wert (z.B. 3)
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
