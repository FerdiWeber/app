import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'study_runner.dart';

typedef SurveyResults = Map<String, dynamic>;

/// ---------------------------------------------------------------------------
/// DATA MODEL
/// ---------------------------------------------------------------------------
class SymptomDefinition {
  final String name;
  final String description;
  final List<String> reactions;

  SymptomDefinition({
    required this.name,
    required this.description,
    required this.reactions,
  });
}

/// ---------------------------------------------------------------------------
/// MAIN SCREEN
/// ---------------------------------------------------------------------------
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

  /// --------------------------------------------------------
  /// DEFINE SYMPTOMS + REACTIONS HERE
  /// --------------------------------------------------------
  final List<SymptomDefinition> symptomList = [
    SymptomDefinition(
      name: "Itchy eyes",
      description: "Eyes feel irritated, watery or itchy.",
      reactions: [
        "Rubbing eyes",
      ],
    ),
    SymptomDefinition(
      name: "Globus sensation",
      description:
          "A feeling of a lump, tightness, or something stuck in the throat.",
      reactions: [
        "Urge to swallow",
      ],
    ),
    SymptomDefinition(
      name: "Itchy palate",
      description: "Tickling/itching sensation on the roof of your mouth.",
      reactions: [
        "Coughing",
        "Throat clearing",
        "Tongue rubbing in the throat",
        "Saliva pumping in the throat",
      ],
    ),
    SymptomDefinition(
      name: "Itchy ears",
      description: "Itching sensation on or inside the ears.",
      reactions: [
        "Rubbing the ears",
      ],
    ),
    SymptomDefinition(
      name: "Running nose",
      description: "A nose that keeps dripping or feels wet.",
      reactions: [
        "Sniffing",
      ],
    ),
  ];

  /// Stores: known? + reaction frequencies
  late Map<String, Map<String, dynamic>> symptomAnswers;

  @override
  void initState() {
    super.initState();

    symptomAnswers = {
      for (var symptom in symptomList)
        symptom.name: {
          "known": null,
          "reactions": <String, int?>{
            for (var r in symptom.reactions) r: null,
          },
        },
    };
  }

  /// --------------------------------------------------------
  /// SHOW SYMPTOM QUESTIONS?
  /// --------------------------------------------------------
  bool _shouldShowSymptoms() {
    if (_hadHayFever == true || _hasAllergySymptoms == true) {
      return true;
    }
    return false;
  }

  /// --------------------------------------------------------
  /// SURVEY COMPLETE?
  /// --------------------------------------------------------
  bool _isSurveyComplete() {
    if (_hadHayFever == null || _hasAllergySymptoms == null) return false;

    // If both general questions = NO → no symptoms required
    if (_hadHayFever == false && _hasAllergySymptoms == false) {
      return true;
    }

    // Else: symptoms required
    for (final symptom in symptomList) {
      final data = symptomAnswers[symptom.name]!;
      if (data["known"] == null) return false;

      if (data["known"] == true) {
        for (var r in symptom.reactions) {
          if (data["reactions"][r] == null) return false;
        }
      }
    }
    return true;
  }

  /// ---------------------------------------------------------------------------
  /// UI
  /// ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Symptom Survey")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildGeneralQuestions(),
                const SizedBox(height: 20),
                if (_shouldShowSymptoms()) ...[
                  for (final s in symptomList) _buildSymptomCard(s),
                ],
              ],
            ),
          ),

          /// Continue button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isSurveyComplete() ? _finishSurvey : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------------------------------------
  /// GENERAL QUESTIONS
  /// ---------------------------------------------------------------------------
  Widget _buildGeneralQuestions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Questions",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              "Do you have diagnosed hay fever?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildYesNo(
              currentValue: _hadHayFever,
              onChanged: (v) => setState(() => _hadHayFever = v),
            ),
            const SizedBox(height: 20),
            Text(
              "Do you experience hay fever symptoms?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildYesNo(
              currentValue: _hasAllergySymptoms,
              onChanged: (v) => setState(() => _hasAllergySymptoms = v),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------------------------------------------------------------------
  /// SYMPTOM CARD
  /// ---------------------------------------------------------------------------
  Widget _buildSymptomCard(SymptomDefinition symptom) {
    final state = symptomAnswers[symptom.name]!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symptom.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              symptom.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              "Is this symptom familiar to you?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildYesNo(
              currentValue: state["known"],
              onChanged: (val) {
                setState(() {
                  state["known"] = val;

                  if (val == false) {
                    state["reactions"].updateAll((key, value) => null);
                  }
                });
              },
            ),
            if (state["known"] == true) ...[
              const SizedBox(height: 24),
              Text(
                "How often do you react this way?",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              for (final r in symptom.reactions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildReactionScale(
                    symptomName: symptom.name,
                    reaction: r,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// ---------------------------------------------------------------------------
  /// REACTION SCALE
  /// ---------------------------------------------------------------------------
  Widget _buildReactionScale({
    required String symptomName,
    required String reaction,
  }) {
    final reactionsMap =
        symptomAnswers[symptomName]!["reactions"] as Map<String, dynamic>;

    final int? value = reactionsMap[reaction] as int?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(reaction, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: List.generate(5, (i) => i + 1)
              .map((v) => ButtonSegment(value: v, label: Text("$v")))
              .toList(),
          selected: value == null ? <int>{} : {value},
          multiSelectionEnabled: false,
          emptySelectionAllowed: true,
          showSelectedIcon: false,
          onSelectionChanged: (set) {
            setState(() {
              reactionsMap[reaction] = set.isEmpty ? null : set.first;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Never"),
            Text("Always"),
          ],
        ),
      ],
    );
  }

  /// ---------------------------------------------------------------------------
  /// YES/NO BUTTONS
  /// ---------------------------------------------------------------------------
  Widget _buildYesNo({
    required bool? currentValue,
    required void Function(bool) onChanged,
  }) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(value: true, label: Text("Yes")),
        ButtonSegment(value: false, label: Text("No")),
      ],
      selected: currentValue == null ? {} : {currentValue},
      multiSelectionEnabled: false,
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      onSelectionChanged: (set) {
        if (set.isNotEmpty) onChanged(set.first);
      },
    );
  }

  /// ---------------------------------------------------------------------------
  /// FINISH + LOGGING
  /// ---------------------------------------------------------------------------
  Future<void> _finishSurvey() async {
    final results = <String, dynamic>{};

    results["general"] = {
      "hadHayFever": _hadHayFever,
      "hasAllergySymptoms": _hasAllergySymptoms,
    };

    for (var entry in symptomAnswers.entries) {
      results[entry.key] = entry.value;
    }

    final logger = ExperimentLogger();
    final prefix = "${widget.experimentId}_survey_${DateTime.now()}_";
    await logger.startLogging(prefix, false);

    for (var entry in results.entries) {
      logger.logOtherEvent(
        0,
        "SurveyResults",
        entry.key,
        entry.value.toString(),
      );
    }

    await logger.stopAndWriteLogging(false);

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
}
