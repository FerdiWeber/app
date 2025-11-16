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
      'text': 'This study uses the OpenEarables to measure possible reactions to allergy symptoms. '
          'It aims to evaluate how well the built-in sensors can detect these reactions. '
          'You will first complete a short survey about hay fever symptoms. '
          'The app will then guide you step by step through the recording process. '
          'Before each session, you’ll receive clear instructions and a chance to practice the described reaction — read them carefully, then start recording. '
          'If something goes wrong, you can repeat the recording. '
          'Try to behave as naturally as possible during each session. '
          'There are two types of recordings, which differ in how your actions are marked. Both are explained on the next pages.',
    },
    {
      'text': 'This is the first recording type. '
          'You’ll see yourself on screen while a timer or counter shows the remaining recording time or how many actions you have left. '
          'Press AND hold (!) the "Action" button during the whole time of your reaction. '
          'The button press defines the action period in the recorded data.',
      'image': 'lib/apps/allergy_symptom_tracker/assets/screenshot_1.png',
    },
    {
      'text': 'This is the second recording type. '
          'A green or red frame alternates around the screen, each with a countdown timer and instructions.'
          'When the frame is green, perform the reaction continuously until it turns red again. '
          'During red phases, behave normally. '
          'Each session starts with a red phase, and no button press is needed in this mode.',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: _exitScreen,
                    tooltip: 'Schließen',
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Getting started',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
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
                    final imagePath = page['image'];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            page['text']!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (imagePath != null && imagePath.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              height: 368, // fixe Höhe für beide Screenshots
                              width: double.infinity,
                              child: Image.asset(
                                page['image']!,
                                fit: BoxFit.contain,
                              ),
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
