abstract class SystemRepository {
  Future<String> getLastVisitedPage();
  Future<void> setLastVisitedPage({required String pageRoute});
  Future<String> getLastActiveAudioTab();
  Future<void> setLastActiveAudioTab({required String tabName});
}
