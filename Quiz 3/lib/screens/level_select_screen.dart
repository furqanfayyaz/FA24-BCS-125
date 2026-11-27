import 'package:flutter/material.dart';
import '../services/audio_game_service.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  int _unlockedLevel = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    await AudioGameService.instance.init();
    setState(() {
      _unlockedLevel = AudioGameService.instance.getUnlockedLevel();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 10, // 10 puzzle levels
              itemBuilder: (ctx, index) {
                final levelNum = index + 1;
                final isUnlocked = levelNum <= _unlockedLevel;

                return InkWell(
                  onTap: isUnlocked
                      ? () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => GameScreen(levelNumber: levelNum)),
                          );
                          _loadProgress();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.indigo.shade50 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isUnlocked ? Colors.indigo : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isUnlocked ? Icons.water_drop : Icons.lock,
                          color: isUnlocked ? Colors.indigo : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Level $levelNum',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.indigo.shade900 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
