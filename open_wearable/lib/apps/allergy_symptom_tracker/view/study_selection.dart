import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';

class StudySelection extends StatefulWidget {
  const StudySelection({super.key});

  @override
  State<StudySelection> createState() => _StudySelectionState();
}

class _StudySelectionState extends State<StudySelection> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Option auswählen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PlatformText("Bitte wähle eine Option:"),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedOption,
              hint: const Text("Option wählen"),
              items: const [
                DropdownMenuItem(
                  value: "option1",
                  child: Text("Option 1"),
                ),
                DropdownMenuItem(
                  value: "option2",
                  child: Text("Option 2"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            const SizedBox(height: 20),
            PlatformElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () {
                      showPlatformDialog(
                        context: context,
                        builder: (_) => PlatformAlertDialog(
                          title: const Text("Gestartet!"),
                          content: Text("Du hast gewählt: $_selectedOption"),
                          actions: <Widget>[
                            PlatformDialogAction(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
