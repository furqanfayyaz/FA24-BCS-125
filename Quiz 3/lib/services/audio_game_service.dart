import 'package:shared_preferences/shared_preferences.dart';

class AudioGameService {
  static final AudioGameService instance = AudioGameService._init();
  static const String _keyUnlockedLevel = 'unlocked_level';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyBgmEnabled = 'bgm_enabled';

  SharedPreferences? _prefs;

  AudioGameService._init();

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  int getUnlockedLevel() {
    return _prefs?.getInt(_keyUnlockedLevel) ?? 1;
  }

  Future<void> setUnlockedLevel(int level) async {
    final current = getUnlockedLevel();
    if (level > current) {
      await _prefs?.setInt(_keyUnlockedLevel, level);
    }
  }

  bool isSoundEnabled() {
    return _prefs?.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  bool isBgmEnabled() {
    return _prefs?.getBool(_keyBgmEnabled) ?? true;
  }

  Future<void> setBgmEnabled(bool enabled) async {
    await _prefs?.setBool(_keyBgmEnabled, enabled);
  }
}
