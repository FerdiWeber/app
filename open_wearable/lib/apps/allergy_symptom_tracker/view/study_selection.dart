import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';

class StudySelection extends StatefulWidget {
  const StudySelection({super.key});

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

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Allergy Symptom Tracker"),
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
                        showPlatformDialog(
                          context: context,
                          builder: (_) => PlatformAlertDialog(
                            title: const Text("Gestartet!"),
                            content: Text(
                              "Du hast gewählt: $_selectedOption\n"
                              "Measurement ID: ${_measurementController.text}",
                            ),
                            actions: <Widget>[
                              PlatformDialogAction(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
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
