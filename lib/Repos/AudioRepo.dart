import 'package:media_player/DomainModels/Audio.dart';

abstract class AudioRepository {
  Future<int> createAudioMeta({required Audio audio});
  Future<void> addAudioToPlaylist({
    required int audioId,
    required int playlistId,
  });
  Future<List<Audio>> getAllAudioMeta();
  Future<List<Audio>> getAllAudioInPlaylist({required int playlistId});
  Future<void> updateAudioMeta({required Audio audio});
  Future<void> deleteAudioMetaById({required int id});
  Future<void> deleteAudioMetaByPath({required String path});
}
