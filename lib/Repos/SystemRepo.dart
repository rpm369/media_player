abstract class SystemRepository {
  String getLastVisitedPage();
  Future<void> setLastVisitedPage({required String pageRoute});
  String getLastActiveAudioTab();
  Future<void> setLastActiveAudioTab({required String tabName});
}
