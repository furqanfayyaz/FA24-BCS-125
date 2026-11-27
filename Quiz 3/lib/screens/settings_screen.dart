import 'package:flutter/material.dart';
import '../services/audio_game_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  bool _bgm = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    await AudioGameService.instance.init();
    setState(() {
      _sound = AudioGameService.instance.isSoundEnabled();
      _bgm = AudioGameService.instance.isBgmEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound Effects (Pouring & Victory)'),
            subtitle: const Text('Play audio feedback on puzzle actions'),
            value: _sound,
            onChanged: (val) async {
              setState(() => _sound = val);
              await AudioGameService.instance.setSoundEnabled(val);
            },
          ),
          SwitchListTile(
            title: const Text('Background Music (BGM)'),
            subtitle: const Text('Play soothing puzzle background melodies'),
            value: _bgm,
            onChanged: (val) async {
              setState(() => _bgm = val);
              await AudioGameService.instance.setBgmEnabled(val);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Color Water Sort Game'),
            subtitle: const Text('Quiz 3 • Mobile Application Development (CSC 303)'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Color Water Sort Puzzle Game',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Developed by Furqan Fayyaz (FA24-BCS-125)',
              );
            },
          ),
        ],
      ),
    );
  }
}
