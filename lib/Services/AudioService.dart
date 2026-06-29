import 'package:media_player/DomainModels/Audio.dart';
import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/Repos/AudioRepo.dart';

class AudioService {
  AudioRepository _repo;
  AudioService({required this._repo});

  Future<List<Audio>> loadAllAudio() async {}

  Future<void> addToPlaylist({
    required Audio audio,
    required Playlist playlist,
  }) async {}
  Future<void> toggletFavoriteStatus({required Audio audio}) async {}
  Future<void> deleteAudio({required Audio audio}) async {}
  Future<void> renameAudio({
    required Audio audio,
    required String newName,
  }) async {}
}
