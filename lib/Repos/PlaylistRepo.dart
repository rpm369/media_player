import 'package:media_player/DomainModels/Playlist.dart';

abstract class PlaylistRepository {
  Future<int> createPlaylist({required Playlist playlist});
  Future<List<Playlist>> getAllPlaylist();
  Future<void> deletePlaylist({required int id});
}
