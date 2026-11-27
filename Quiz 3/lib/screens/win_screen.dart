import 'package:flutter/material.dart';

class WinScreen extends StatelessWidget {
  final int levelNumber;
  final VoidCallback onNextLevel;
  final VoidCallback onReplay;

  const WinScreen({
    super.key,
    required this.levelNumber,
    required this.onNextLevel,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'Level Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 8),
            Text(
              'Great job sorting level $levelNumber!',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 36, color: Colors.amber),
                SizedBox(width: 8),
                Icon(Icons.star, size: 44, color: Colors.amber),
                SizedBox(width: 8),
                Icon(Icons.star, size: 36, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReplay,
                    child: const Text('Replay'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNextLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Next Level'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
