import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/audio_game_service.dart';
import '../widgets/bottle_widget.dart';
import 'win_screen.dart';

class GameScreen extends StatefulWidget {
  final int levelNumber;

  const GameScreen({super.key, required this.levelNumber});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Bottle> _bottles;
  int? _selectedBottleIndex;
  int _moves = 0;
  final List<List<Bottle>> _history = [];

  @override
  void initState() {
    super.initState();
    _initLevel(widget.levelNumber);
  }

  void _initLevel(int level) {
    _moves = 0;
    _selectedBottleIndex = null;
    _history.clear();

    // Generate puzzle bottles based on level difficulty
    if (level == 1) {
      _bottles = [
        Bottle(colors: [Colors.red, Colors.blue, Colors.red, Colors.blue]),
        Bottle(colors: [Colors.blue, Colors.red, Colors.blue, Colors.red]),
        Bottle(colors: []),
      ];
    } else if (level == 2) {
      _bottles = [
        Bottle(colors: [Colors.green, Colors.orange, Colors.green, Colors.orange]),
        Bottle(colors: [Colors.orange, Colors.green, Colors.orange, Colors.green]),
        Bottle(colors: []),
        Bottle(colors: []),
      ];
    } else {
      // General multi-color level generator
      _bottles = [
        Bottle(colors: [Colors.red, Colors.blue, Colors.green, Colors.orange]),
        Bottle(colors: [Colors.blue, Colors.green, Colors.orange, Colors.red]),
        Bottle(colors: [Colors.green, Colors.orange, Colors.red, Colors.blue]),
        Bottle(colors: []),
        Bottle(colors: []),
      ];
    }
  }

  void _saveHistory() {
    _history.add(_bottles.map((b) => b.clone()).toList());
  }

  bool _checkWin() {
    return _bottles.every((b) => b.isEmpty || b.isMonochrome);
  }

  void _onBottleTap(int index) {
    setState(() {
      if (_selectedBottleIndex == null) {
        if (!_bottles[index].isEmpty) {
          _selectedBottleIndex = index;
        }
      } else {
        if (_selectedBottleIndex == index) {
          _selectedBottleIndex = null; // deselect
        } else {
          // Attempt to pour from _selectedBottleIndex to index
          _pourLiquid(_selectedBottleIndex!, index);
          _selectedBottleIndex = null;
        }
      }
    });
  }

  void _pourLiquid(int fromIdx, int toIdx) {
    final fromBottle = _bottles[fromIdx];
    final toBottle = _bottles[toIdx];

    if (fromBottle.isEmpty) return;
    if (toBottle.isFull) return;

    final topColor = fromBottle.topColor;
    if (toBottle.isEmpty || toBottle.topColor == topColor) {
      _saveHistory();
      // Pour continuous matching color blocks
      while (!fromBottle.isEmpty && fromBottle.topColor == topColor && !toBottle.isFull) {
        toBottle.colors.add(fromBottle.colors.removeLast());
      }
      _moves++;

      if (_checkWin()) {
        _handleWin();
      }
    }
  }

  Future<void> _handleWin() async {
    await AudioGameService.instance.setUnlockedLevel(widget.levelNumber + 1);
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => WinScreen(
          levelNumber: widget.levelNumber,
          onNextLevel: () {
            Navigator.pop(ctx);
            if (widget.levelNumber < 10) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => GameScreen(levelNumber: widget.levelNumber + 1)),
              );
            } else {
              Navigator.pop(context);
            }
          },
          onReplay: () {
            Navigator.pop(ctx);
            setState(() => _initLevel(widget.levelNumber));
          },
        ),
      );
    }
  }

  void _undo() {
    if (_history.isNotEmpty) {
      setState(() {
        _bottles = _history.removeLast();
        _selectedBottleIndex = null;
        _moves = (_moves > 0) ? _moves - 1 : 0;
      });
    }
  }

  void _restart() {
    setState(() {
      _initLevel(widget.levelNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.levelNumber}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _history.isNotEmpty ? _undo : null,
            tooltip: 'Undo Move',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restart,
            tooltip: 'Restart Level',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Level Status & Moves Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Moves: $_moves',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                const Text(
                  'Sort same colors together!',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Bottles Grid Area
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: List.generate(_bottles.length, (index) {
                    return BottleWidget(
                      bottle: _bottles[index],
                      isSelected: _selectedBottleIndex == index,
                      onTap: () => _onBottleTap(index),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
