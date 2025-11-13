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

import 'symptom_survey.dart';

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
      setState(() {}); // Updates button color on text input
    });
  }

  @override
  void dispose() {
    _measurementController.dispose(); // Free up memory
    super.dispose();
  }

  Future<void> _exportLogFiles() async {
    // 1. Find all CSV log files
    final List<File> logFiles = await ExperimentLogger.getAllLogFiles();

    // 2. Find video files (.mp4)
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();
    for (var file in allFiles) {
      if (file is File &&
          (file.path.endsWith('.mp4') || file.path.endsWith('.csv'))) {
        // Added .csv in case getAllLogFiles missed something
        if (!logFiles.any((existing) => existing.path == file.path)) {
          logFiles.add(file);
        }
      }
    }

    if (logFiles.isEmpty) {
      print("No log files found to share.");
      // Optional: Show a message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No log files found to export.")),
        );
      }
      return;
    }

    // 3. Convert File objects to XFile objects
    final List<XFile> filesToShare =
        logFiles.map((file) => XFile(file.path)).toList();

    // 4. Open the "Share" dialog
    try {
      await Share.shareXFiles(
        filesToShare,
        text: 'Allergy Symptom Tracker Log Files',
      );
    } catch (e) {
      print("Error while sharing: $e");
    }
  }

  Future<void> _deleteLogFiles() async {
    // 1. Find all log files (CSV and MP4)
    final List<File> filesToDelete = await ExperimentLogger.getAllLogFiles();

    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();
    for (var file in allFiles) {
      // Add MP4 files
      if (file is File && file.path.endsWith('.mp4')) {
        if (!filesToDelete.any((existing) => existing.path == file.path)) {
          filesToDelete.add(file);
        }
      }
    }

    if (filesToDelete.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No logs found to delete.")),
        );
      }
      return;
    }

    // 2. Show confirmation dialog (with text field)
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must interact with the dialog
      builder: (BuildContext context) {
        final TextEditingController confirmController = TextEditingController();
        const String confirmationText = 'delete';
        bool isDeleteEnabled = false;

        // Use StatefulBuilder to update the dialog's state
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Do you really want to permanently delete ${filesToDelete.length} log files (CSV and MP4)?'),
                  const SizedBox(height: 16),
                  const Text(
                    "This action cannot be undone. To confirm, please type 'delete' below:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: confirmationText,
                    ),
                    onChanged: (value) {
                      setState(() {
                        isDeleteEnabled =
                            value.trim().toLowerCase() == confirmationText;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  // Button is disabled (onPressed: null) until text matches
                  onPressed: isDeleteEnabled
                      ? () => Navigator.of(context).pop(true)
                      : null,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: isDeleteEnabled ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // 3. If confirmed, delete all files
    if (confirmed == true) {
      int deleteCount = 0;
      try {
        for (final file in filesToDelete) {
          // Use the static delete method from the logger
          await ExperimentLogger.deleteLogFile(file);
          deleteCount++;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$deleteCount files deleted.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting files: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Allergy Symptom Tracker"),
        trailingActions: <Widget>[
          PlatformIconButton(
            icon: Icon(
              PlatformIcons(context).share,
            ),
            //tooltip: 'Export logs', // Translated
            onPressed: _exportLogFiles,
          ),
          PlatformIconButton(
            icon: Icon(PlatformIcons(context).delete), // Trash can icon
            //tooltip: 'Delete logs', // Translated
            onPressed: _deleteLogFiles, // Calls your new delete function
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter, // only horizontally centered
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, _topSpacing, 32, 16),

          // Container added as a frame
          child: Container(
            padding: const EdgeInsets.all(20.0), // Inner padding for the frame
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!), // Frame color
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // only as high as needed
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlatformText(
                  "Please select Dataset and Measurement ID to continue with",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedOption,
                  hint: const Text("Choose Dataset"),
                  borderRadius: BorderRadius.circular(12.0),
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
                    DropdownMenuItem(
                      value: "option 3",
                      child: Text("Dataset 3"),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

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
                // Start-Button
                PlatformElevatedButton(
                  onPressed: (_selectedOption == null ||
                          _measurementController.text.isEmpty)
                      ? null
                      : () {
                          // 1. Daten aus StudySelection sammeln
                          late final StudyProtocol selectedProtocol;
                          if (_selectedOption == "option1") {
                            selectedProtocol = Dataset1Protocol();
                          } else if (_selectedOption == "option2") {
                            selectedProtocol = Dataset2Protocol();
                          } else {
                            selectedProtocol = Dataset3Protocol();
                          }

                          // 2. Navigiere zum ExplanationScreen
                          Navigator.push(
                            context,
                            platformPageRoute(
                              context: context,
                              builder: (_) => ExplanationScreen(
                                // 3. Als 'nextScreen' übergeben wir den SurveyScreen
                                nextScreen: SymptomSurveyScreen(
                                  // 4. Wir reichen ALLE Daten an den SurveyScreen weiter
                                  protocol: selectedProtocol,
                                  experimentId: _measurementController.text,
                                  leftWearable: widget.leftWearable,
                                  rightWearable: widget.rightWearable,
                                  leftConfigProvider: widget.leftConfigProvider,
                                  rightConfigProvider:
                                      widget.rightConfigProvider,
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
      ),
    );
  }
}
