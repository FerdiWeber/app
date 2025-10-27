import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

import 'package:open_wearable/apps/allergy_symptom_tracker/model/study_protocol.dart';
import 'study_runner.dart';
import 'explanation_screen.dart';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_wearable/apps/allergy_symptom_tracker/controller/logger.dart';

class StudySelection extends StatefulWidget {
  // Hinzufügen der benötigten Parameter
  final Wearable leftWearable;
  final Wearable rightWearable;
  final SensorConfigurationProvider leftConfigProvider;
  final SensorConfigurationProvider rightConfigProvider;

  const StudySelection({
    super.key,
    required this.leftWearable,
    required this.rightWearable,
    required this.leftConfigProvider,
    required this.rightConfigProvider,
  });

  @override
  State<StudySelection> createState() => _StudySelectionState();
}

class _StudySelectionState extends State<StudySelection> {
  String? _selectedOption;
  final TextEditingController _measurementController = TextEditingController();

  final double _topSpacing = 80.0;

  @override
  void initState() {
    super.initState();
    _measurementController.addListener(() {
      setState(() {}); // aktualisiert Buttonfarbe bei Texteingabe
    });
  }

  @override
  void dispose() {
    _measurementController.dispose(); // Speicher freigeben
    super.dispose();
  }

  Future<void> _exportLogFiles() async {
    // 1. Finde alle CSV-Logdateien
    final List<File> logFiles = await ExperimentLogger.getAllLogFiles();

    // 2. Finde die Video-Dateien (.mp4)
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();
    for (var file in allFiles) {
      if (file is File &&
          (file.path.endsWith('.mp4') || file.path.endsWith('.csv'))) {
        // .csv hinzugefügt, falls getAllLogFiles nicht alle erwischt
        if (!logFiles.any((existing) => existing.path == file.path)) {
          logFiles.add(file);
        }
      }
    }

    if (logFiles.isEmpty) {
      print("Keine Log-Dateien zum Teilen gefunden.");
      // Optional: Zeige dem Benutzer eine Meldung
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Keine Log-Dateien zum Exportieren gefunden.")),
      );
      return;
    }

    // 3. Konvertiere File-Objekte in XFile-Objekte
    final List<XFile> filesToShare =
        logFiles.map((file) => XFile(file.path)).toList();

    // 4. Öffne den "Teilen"-Dialog
    try {
      await Share.shareXFiles(
        filesToShare,
        text: 'Allergie-Tagebuch Log-Dateien',
      );
    } catch (e) {
      print("Fehler beim Teilen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Allergy Symptom Tracker"),

        // HIER IST DIE HINZUGEFÜGTE ÄNDERUNG:
        trailingActions: <Widget>[
          PlatformIconButton(
            // Verwende PlatformIconButton statt IconButton
            icon: Icon(
              PlatformIcons(context).share,
            ), // Holt das plattformspezifische Share-Icon
            //tooltip: 'Logs exportieren',
            onPressed: _exportLogFiles, // Ruft deine Export-Funktion auf
          ),
        ],
        // ENDE DER ÄNDERUNG
      ),
      body: Align(
        alignment: Alignment.topCenter, // nur horizontal zentriert
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, _topSpacing, 32, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // nur so hoch wie nötig
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlatformText(
                "Please select Dataset and Measurment ID to continue with",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Dropdown für Dataset-Auswahl
              DropdownButtonFormField<String>(
                initialValue: _selectedOption,
                hint: const Text("Choose Dataset"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "option1",
                    child: Text("Dataset 1"),
                  ),
                  DropdownMenuItem(
                    value: "option2",
                    child: Text("Dataset 2"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Eingabefeld für Measurement ID
              TextFormField(
                controller: _measurementController,
                decoration: InputDecoration(
                  labelText: "Enter Measurement ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 20),

              // Start-Button
              PlatformElevatedButton(
                onPressed: (_selectedOption == null ||
                        _measurementController.text.isEmpty)
                    ? null
                    : () {
                        late final StudyProtocol selectedProtocol;
                        if (_selectedOption == "option1") {
                          selectedProtocol = Dataset1Protocol();
                        } else {
                          selectedProtocol = Dataset2Protocol();
                        }

                        // Navigiere zum ExplanationScreen und übergebe ALLE Daten
                        Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (_) => ExplanationScreen(
                              nextScreen: StudyRunner(
                                protocol: selectedProtocol,
                                experimentId: _measurementController.text,
                                leftWearable: widget.leftWearable,
                                rightWearable: widget.rightWearable,
                                leftConfigProvider: widget.leftConfigProvider,
                                rightConfigProvider: widget.rightConfigProvider,
                              ),
                            ),
                          ),
                        );
                      },
                material: (_, __) => MaterialElevatedButtonData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_selectedOption != null &&
                            _measurementController.text.isNotEmpty)
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
                child: const Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
