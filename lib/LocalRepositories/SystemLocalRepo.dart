import 'package:media_player/Databases/SystemDb.dart';
import 'package:media_player/Repos/SystemRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemLocalRepo implements SystemRepository {
  final SharedPreferences _db;
  SystemLocalRepo({required this._db});

  @override
  String getLastActiveAudioTab() {
    return _db.getString(SystemConst.LAST_VISITED_AUDIO_TAB.id)!;
  }

  @override
  String getLastVisitedPage() {
    return _db.getString(SystemConst.LAST_VISITED_PAGE.id)!;
  }

  @override
  Future<void> setLastActiveAudioTab({required String tabName}) async {
    await _db.setString(SystemConst.LAST_VISITED_AUDIO_TAB.id, tabName);
  }

  @override
  Future<void> setLastVisitedPage({required String pageRoute}) async {
    await _db.setString(SystemConst.LAST_VISITED_PAGE.id, pageRoute);
  }
}
