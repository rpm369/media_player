import 'package:media_player/Repos/SystemRepo.dart';

class SystemService {
  final SystemRepository _repo;
  const SystemService({required this._repo});

  String getLastVisitedPage() {
    return _repo.getLastVisitedPage();
  }

  Future<void> setLastVisitedPage({required String pageRoute}) async {
    await _repo.setLastVisitedPage(pageRoute: pageRoute);
  }

  String getLastActiveAudioTab() {
    return _repo.getLastActiveAudioTab();
  }

  Future<void> setLastActiveAudioTab({required String tabName}) async {
    await _repo.setLastActiveAudioTab(tabName: tabName);
  }
}
