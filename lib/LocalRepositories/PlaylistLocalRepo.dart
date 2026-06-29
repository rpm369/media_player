import 'package:media_player/DataModels/PlaylistModel.dart';
import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/Repos/PlaylistRepo.dart';
import 'package:sqflite/sqflite.dart';

class PlaylistLocalRepo implements PlaylistRepository {
  final Database _db;
  const PlaylistLocalRepo({required this._db});

  @override
  Future<int> createPlaylist({required Playlist playlist}) async {
    final model = PlaylistModel.fromPlaylist(playlist: playlist);
    return await _db.insert('Playlist', model.toJson());
  }

  @override
  Future<void> deletePlaylist({required int id}) async {
    await _db.delete('Playlist', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Playlist>> getAllPlaylist() async {
    final List<Map<String, dynamic>> maps = await _db.query('Playlist');
    return maps
        .map((map) => PlaylistModel.fromJson(json: map).toPlaylist())
        .toList();
  }

  @override
  Future<void> updatePlaylist({required Playlist playlist}) async {
    PlaylistModel playlistModel = PlaylistModel.fromPlaylist(
      playlist: playlist,
    );
    await _db.update(
      'Playlist',
      playlistModel.toJson(),
      where: "id = ?",
      whereArgs: [playlistModel.id!],
    );
  }
}
