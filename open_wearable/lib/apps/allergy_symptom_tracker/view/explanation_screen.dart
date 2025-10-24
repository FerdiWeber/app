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
      'text': 'Im folgenden werden Reaktionen auf Allergie Symptome gemessen. Dazu siehst du immer zuerst eine Erklärung dafür, was du tun sollst.'
          'Hast du die Erklärung durchglesen und verstanden, und die Aufzeichnung startest, gibt es zwei verschiedene Arten der Aufzeichnung. Die erste Siehst du hier.'
          'Es du siehts dich selbst. Dazu läuft ein Timer wie lange die Aufzeichnung noch läuft. Bei dieser Variante gibt es einen Action Button. Betätige diesen immer exakt'
          'zeitlich wenn du die Raktion durchführst',
      'image': 'lib/apps/allergy_symptom_tracker/assets/screenshot_1.png',
    },
    {
      'text': 'Hier siehts du die zweite Art wie aufgezeichnet wird. Man sieht abwechslen einen grünen Rahmen und einen roten. Beide sind mit einem Timer versehen, welcher anzeigt,'
          'wie lange die aktuelle Farbe noch bestehen bleibt. Sobald der Rahmen grün ist, soll die Reaktion so lange ununterbrochen durchgeführt werden, bis der Rahemn rot wird. Während der'
          'Rahmen rot ist, soll nichts geatn werden',
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
                    _currentPage == _pages.length - 1 ? 'Starten' : 'Weiter',
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
