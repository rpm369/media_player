import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/Repos/PlaylistRepo.dart';

class PlaylistService {
  final PlaylistRepository _repo;
  const PlaylistService({required this._repo});

  Future<List<Playlist>> getAllPlaylists() async {}
  Future<void> rename({
    required Playlist playlist,
    required String newName,
  }) async {}
  Future<void> delete({required Playlist playlist}) async {}
  Future<void> toggleFavoriteStatus({required Playlist playlist}) async {}
}
