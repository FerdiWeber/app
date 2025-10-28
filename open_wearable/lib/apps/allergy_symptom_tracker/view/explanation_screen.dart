import 'package:flutter/material.dart';

class ExplanationScreen extends StatefulWidget {
  /// Das Widget, das nach dem letzten Schritt gestartet wird
  final Widget nextScreen;

  const ExplanationScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'text': 'In den folgenden Schritten werden deine Reaktionen auf Allergiesymptome gemessen. '
          'Die App führt dich dabei Schritt für Schritt durch den Prozess. '
          'Vor jeder Messung erhältst du eine kurze Erklärung, was du tun sollst. '
          'Nachdem du die Erklärung gelesen und verstanden hast, kannst du die Aufzeichnung starten. '
          'Grundsätzlich gilt: Verhalte dich während der Aufzeichnung ganz normal. '
          'In der Studie werden zwei Arten von Aufzeichnungen verwendet. '
          'Diese unterscheiden sich darin, wie markiert wird, wann du deine Reaktion ausführst. '
          'Die erste Variante siehst du hier: '
          'Du siehst dich selbst auf dem Bildschirm, während ein Timer die verbleibende Aufzeichnungszeit anzeigt. '
          'In dieser Variante gibt es einen „Action“-Button. Drücke ihn immer genau zu Beginn deiner Reaktion. '
          'Der Button dient später als Markierung in den Messdaten für den Start deiner Reaktion.',
      'image': 'lib/apps/allergy_symptom_tracker/assets/screenshot_1.png',
    },
    {
      'text': 'Hier siehst du die zweite Art der Aufzeichnung. '
          'Dabei erscheint abwechselnd ein grüner oder ein roter Rahmen um das Bild. '
          'Beide Phasen sind mit einem Timer versehen, der anzeigt, wie lange die aktuelle Farbe noch besteht. '
          'Sobald der Rahmen grün ist, führe die Reaktion kontinuierlich aus, bis der Rahmen wieder rot wird. '
          'Während der roten Phasen verhalte dich bitte ganz normal. '
          'Eine Aufzeichnung mit dieser Art startet immer mit einer roten Phase.'
          'Bei dieser Variante musst du keinen Button betätigen.',
      'image': 'lib/apps/allergy_symptom_tracker/assets/screenshot_2.png',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _startStudy();
    }
  }

  void _startStudy() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.nextScreen),
    );
  }

  void _exitScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Obere Leiste mit "X"-Button und Überschrift
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Zurück-Button oder "X"
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: _exitScreen,
                    tooltip: 'Schließen',
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Erklärung',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 48), // Platzhalter für zentrierte Überschrift
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            page['text']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: Image.asset(
                            page['image']!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isActive = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 12 : 8,
                    height: isActive ? 12 : 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.blueAccent : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Begin Study' : 'Next',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
