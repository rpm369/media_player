import 'package:media_player/Repos/SystemRepo.dart';

class SystemService {
  final SystemRepository _repo;
  const SystemService({required this._repo});

  Future<String> getLastVisitedPage() async {}
  Future<void> setLastVisitedPage({required String pageRoute}) async {}
  Future<String> getLastActiveAudioTab() async {}
  Future<void> setLastActiveAudioTab({required String tabName}) async {}
}
