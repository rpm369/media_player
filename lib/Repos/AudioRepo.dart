import 'package:media_player/DomainModels/Audio.dart';

abstract class AudioRepository {
  Future<int> createAudioMeta({required Audio audio});
  Future<List<Audio>> getAllAudioMeta();
  Future<void> updateAudioMeta({required Audio audio});
  Future<void> deleteAudioMeta({required int id});
}
