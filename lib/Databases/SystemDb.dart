import 'package:shared_preferences/shared_preferences.dart';

class SystemDb {
  SystemDb._();
  static SharedPreferences? _db;

  static Future<SharedPreferences> get getDatabase async {
    if (_db == null) await _initialize();
    return _db!;
  }

  static Future<void> _initialize() async {
    if (_db != null) return;
    _db = await SharedPreferences.getInstance();

    if (_db!.getKeys().isEmpty) {
      await _db!.setString(SystemConst.LAST_VISITED_PAGE.id, '/Browse');
      await _db!.setString(SystemConst.LAST_VISITED_AUDIO_TAB.id, '/Tracks');
    }
  }
}

enum SystemConst {
  LAST_VISITED_PAGE('lastVisitedPage'),
  LAST_VISITED_AUDIO_TAB('lastVisitedAudioTab');

  final String id;
  const SystemConst(this.id);
}
