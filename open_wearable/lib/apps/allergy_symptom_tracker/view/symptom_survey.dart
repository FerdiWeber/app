import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'study_runner.dart';

typedef SurveyResults = Map<String, Map<String, int>>;

class SymptomSurveyScreen extends StatefulWidget {
  final StudyProtocol protocol;
  final String experimentId;
  final Wearable leftWearable;
  final Wearable rightWearable;
  final SensorConfigurationProvider leftConfigProvider;
  final SensorConfigurationProvider rightConfigProvider;

  const SymptomSurveyScreen({
    super.key,
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
  bool? _hadHayFever;
  bool? _hasAllergySymptoms;

  final List<String> _symptoms = [
    'Urge to swallow',
    'Itchy palate',
    'Itchy eyes',
    'Cough',
    'Itchy ears',
    'Frequent throat clearing',
  ];

  late final Map<String, Map<String, int?>> _answers;

  @override
  void initState() {
    super.initState();
    _answers = {
      for (var symptom in _symptoms)
        symptom: {
          'familiarity': null,
          'frequency': null,
        }
    };
  }

  bool _isSurveyComplete() {
    if (_hadHayFever == null || _hasAllergySymptoms == null) return false;
    for (var symptom in _symptoms) {
      if (_answers[symptom]!['familiarity'] == null ||
          _answers[symptom]!['frequency'] == null) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Survey'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _symptoms.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildGeneralQuestionsCard();
                final symptom = _symptoms[index - 1];
                return _buildSymptomCard(symptom);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isSurveyComplete()
                  ? () async {
                      final SurveyResults results =
                          _answers.map((symptom, questions) {
                        return MapEntry(symptom, questions.map((key, value) {
                          return MapEntry(key, value!);
                        }));
                      });

                      results['general'] = {
                        'hadHayFever': _hadHayFever! ? 1 : 0,
                        'hasAllergySymptoms': _hasAllergySymptoms! ? 1 : 0,
                      };

                      final logger = ExperimentLogger();
                      final date = null;
                      final prefix = '${widget.experimentId}_survey_${date}_';
                      await logger.startLogging(prefix, false);

                      for (var entry in results.entries) {
                        final symptom = entry.key;
                        final data = entry.value;
                        if (symptom == 'general') {
                          logger.logOtherEvent(
                            0,
                            "SurveyResults",
                            symptom,
                            "hadHayFever: ${data['hadHayFever']}, hasAllergySymptoms: ${data['hasAllergySymptoms']}",
                          );
                        } else {
                          logger.logOtherEvent(
                            0,
                            "SurveyResults",
                            symptom,
                            "familiarity: ${data['familiarity']}, frequency: ${data['frequency']}",
                          );
                        }
                      }

                      await logger.stopAndWriteLogging(false);
                      print("✅ Survey results saved to separate CSV file.");

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (_) => StudyRunner(
                              protocol: widget.protocol,
                              experimentId: widget.experimentId,
                              leftWearable: widget.leftWearable,
                              rightWearable: widget.rightWearable,
                              leftConfigProvider: widget.leftConfigProvider,
                              rightConfigProvider: widget.rightConfigProvider,
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralQuestionsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('General Questions',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Question 1
            Text('Do you have diagnosed hay fever?',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildYesNoButtons(
              currentValue: _hadHayFever,
              onChanged: (val) => setState(() => _hadHayFever = val),
            ),

            const SizedBox(height: 24),

            // Question 2
            Text('Do you experience hay fever symptoms?',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildYesNoButtons(
              currentValue: _hasAllergySymptoms,
              onChanged: (val) => setState(() => _hasAllergySymptoms = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYesNoButtons({
    required bool? currentValue,
    required void Function(bool) onChanged,
  }) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(value: true, label: Text('Yes')),
        ButtonSegment(value: false, label: Text('No')),
      ],
      selected: currentValue == null ? {} : {currentValue},
      multiSelectionEnabled: false,
      showSelectedIcon: false,
      emptySelectionAllowed: true,
      onSelectionChanged: (Set<bool> newSel) {
        if (newSel.isNotEmpty) onChanged(newSel.first);
      },
    );
  }

  Widget _buildSymptomCard(String symptom) {
    final descriptions = {
      'Urge to swallow': 'A frequent feeling that you need to swallow.',
      'Itchy palate':
          'An itching sensation on the roof of your mouth, common with allergies.',
      'Itchy eyes':
          'Eyes that feel irritated, watery, or itchy due to allergic reactions.',
      'Cough':
          'A reflex action to clear your airways of mucus or irritants, often worsened by allergies.',
      'Itchy ears':
          'A tickling or irritating feeling inside the ears, typical during pollen season.',
      'Frequent throat clearing':
          'Needing to clear your throat repeatedly, often because of mucus buildup.',
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(symptom, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              descriptions[symptom] ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            // Frequency
            _buildQuestion(
              question:
                  'If I have a symptom, this is how often I use this reaction:', //andere fomulierung mit andere skala
              symptom: symptom,
              questionKey: 'frequency',
              numSegments: 5,
              labels: ['Never use', 'Frequently use'],
            ),

            const SizedBox(height: 24),

            // Familiarity
            _buildQuestion(
              question:
                  'If I have hay fever symptoms, how familiar does this reaction feel to me?',
              symptom: symptom,
              questionKey: 'familiarity',
              numSegments: 5,
              labels: ['Not at all familiar', 'Extremely familiar'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required String question,
    required String symptom,
    required String questionKey,
    required int numSegments,
    required List<String> labels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: List.generate(numSegments, (i) => i + 1).map((value) {
            return ButtonSegment<int>(
              value: value,
              label: Text(value.toString()),
            );
          }).toList(),
          selected: {_answers[symptom]![questionKey]}.whereType<int>().toSet(),
          multiSelectionEnabled: false,
          showSelectedIcon: false,
          emptySelectionAllowed: true,
          onSelectionChanged: (Set<int> newSelection) {
            setState(() {
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
        ),
      ],
    );
  }
}
