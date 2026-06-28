import 'package:media_player/DataModels/AudioModel.dart';
import 'package:media_player/DataModels/AudioInfoModel.dart';
import 'package:media_player/DomainModels/Audio.dart';
import 'package:media_player/Repos/AudioRepo.dart';
import 'package:sqflite/sqflite.dart';

class AudioLocalRepo implements AudioRepository {
  final Database _db;
  const AudioLocalRepo({required this._db});

  @override
  Future<int> createAudioMeta({required Audio audio}) async {
    return await _db.transaction<int>((txn) async {
      final audioModel = AudioModel.fromAudio(audio: audio);
      final audioId = await txn.insert('Audio', audioModel.toJson());

      final audioInfo = audio.audioInfo;
      if (audioInfo != null) {
        final audioInfoModel = AudioInfoModel.fromAudioInfo(
          audioInfo: audioInfo,
          audioId: audioId,
        );
        await txn.insert('AudioInfo', audioInfoModel.toJson());
      }

      return audioId;
    });
  }

  @override
  Future<void> deleteAudioMeta({required int id}) async {
    await _db.delete('Audio', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Audio>> getAllAudioMeta() async {
    final List<Map<String, dynamic>> audioMaps = await _db.query('Audio');

    final List<Future<Audio?>> futures = audioMaps.map((audioMap) async {
      final audioModel = AudioModel.fromJson(json: audioMap);
      final audioId = audioModel.id;
      if (audioId == null) return null;

      final audioInfoMaps = await _db.query(
        'AudioInfo',
        where: 'audioId = ? AND videoId IS NULL',
        whereArgs: [audioId],
      );

      if (audioInfoMaps.isEmpty) {
        return null;
      }

      final audioInfoModel = AudioInfoModel.fromJson(json: audioInfoMaps.first);

      return audioModel.toAudio(audioInfo: audioInfoModel.toAudioInfo());
    }).toList();

    final List<Audio?> resolvedAudios = await Future.wait(futures);
    return resolvedAudios.whereType<Audio>().toList();
  }

  @override
  Future<List<Audio>> getAllAudioInPlaylist({required int playlistId}) async {
    final List<Map<String, dynamic>> audioMaps = await _db.rawQuery('''
      SELECT Audio.* FROM Audio
      INNER JOIN PlaylistAudio ON Audio.id = PlaylistAudio.audioId
      WHERE PlaylistAudio.playlistId = ?
    ''', [playlistId]);

    final List<Future<Audio?>> futures = audioMaps.map((audioMap) async {
      final audioModel = AudioModel.fromJson(json: audioMap);
      final audioId = audioModel.id;
      if (audioId == null) return null;

      final audioInfoMaps = await _db.query(
        'AudioInfo',
        where: 'audioId = ? AND videoId IS NULL',
        whereArgs: [audioId],
      );

      if (audioInfoMaps.isEmpty) {
        return null;
      }

      final audioInfoModel = AudioInfoModel.fromJson(json: audioInfoMaps.first);

      return audioModel.toAudio(audioInfo: audioInfoModel.toAudioInfo());
    }).toList();

    final List<Audio?> resolvedAudios = await Future.wait(futures);
    return resolvedAudios.whereType<Audio>().toList();
  }

  @override
  Future<void> updateAudioMeta({required Audio audio}) async {
    final audioId = audio.id;
    if (audioId == null) return;

    await _db.transaction((txn) async {
      final audioModel = AudioModel.fromAudio(audio: audio);
      final audioJson = audioModel.toJson()..remove('id');
      await txn.update(
        'Audio',
        audioJson,
        where: 'id = ?',
        whereArgs: [audioId],
      );

      final audioInfo = audio.audioInfo;
      if (audioInfo != null) {
        final audioInfoModel = AudioInfoModel.fromAudioInfo(
          audioInfo: audioInfo,
          audioId: audioId,
        );
        final audioInfoJson = audioInfoModel.toJson()..remove('id');
        await txn.update(
          'AudioInfo',
          audioInfoJson,
          where: 'audioId = ? AND videoId IS NULL',
          whereArgs: [audioId],
        );
      }
    });
  }
}
