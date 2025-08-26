import 'package:flutter/material.dart';
import '../screens/learn_screen.dart';
import '../screens/category_screen.dart';
import '../screens/progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Use a fixed width to prevent text wrapping and ensure uniformity
    const buttonWidth = 200.0; // Adjusted to fit "Knowledge Check" on one line

    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteBasics'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Text(
                'Master Computer Basics with ByteBasics!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(buttonWidth, 48), // Ensure consistent height
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LearnScreen()),
                  );
                },
                child: const Text('Learn'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(buttonWidth, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  );
                },
                child: const Text('Knowledge Check'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(buttonWidth, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProgressScreen()),
                  );
                },
                child: const Text('View Progress'),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Chip(
                label: const Text('Powered by Satyarth Programming Hub'),
                backgroundColor: colorScheme.primaryContainer,
                labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}