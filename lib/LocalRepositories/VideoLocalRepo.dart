import 'package:media_player/DataModels/VideoModel.dart';
import 'package:media_player/DataModels/VideoInfoModel.dart';
import 'package:media_player/DataModels/AudioInfoModel.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/Repos/VideoRepo.dart';
import 'package:sqflite/sqflite.dart';

class VideoLocalRepo implements VideoRepository {
  final Database _db;
  VideoLocalRepo({required this._db});

  @override
  Future<int> createVideoMeta({required Video video}) async {
    return await _db.transaction<int>((txn) async {
      VideoModel videoModel = VideoModel.fromVideo(video: video);
      final videoId = await txn.insert('Video', videoModel.toJson());

      final videoInfoModel = VideoInfoModel.fromVideoInfo(
        videoInfo: video.videoInfo,
        videoId: videoId,
      );
      await txn.insert('VideoInfo', videoInfoModel.toJson());

      final audioInfoModel = AudioInfoModel.fromAudioInfo(
        audioInfo: video.audioInfo,
        videoId: videoId,
      );
      await txn.insert('AudioInfo', audioInfoModel.toJson());

      return videoId;
    });
  }

  @override
  Future<void> deleteVideoMeta({required int videoId}) async {
    await _db.delete('Video', where: 'id = ?', whereArgs: [videoId]);
  }

  @override
  Future<List<Video>> getAllVideosMeta() async {
    final List<Map<String, dynamic>> videoMaps = await _db.query('Video');

    final List<Future<Video?>> futures = videoMaps.map((videoMap) async {
      final videoModel = VideoModel.fromJson(json: videoMap);
      final videoId = videoModel.id;
      if (videoId == null) return null;

      final videoInfoFutures = _db.query(
        'VideoInfo',
        where: 'videoId = ?',
        whereArgs: [videoId],
      );

      final audioInfoFutures = _db.query(
        'AudioInfo',
        where: 'videoId = ? AND audioId IS NULL',
        whereArgs: [videoId],
      );

      final results = await Future.wait([videoInfoFutures, audioInfoFutures]);
      final videoInfoMaps = results[0];
      final audioInfoMaps = results[1];

      if (videoInfoMaps.isEmpty || audioInfoMaps.isEmpty) {
        return null;
      }

      final videoInfoModel = VideoInfoModel.fromJson(json: videoInfoMaps.first);
      final audioInfoModel = AudioInfoModel.fromJson(json: audioInfoMaps.first);

      return videoModel.toVideo(
        audioInfoModel: audioInfoModel,
        videoInfoModel: videoInfoModel,
      );
    }).toList();

    final List<Video?> resolvedVideos = await Future.wait(futures);
    return resolvedVideos.whereType<Video>().toList();
  }

  @override
  Future<List<Video>> getAllVideosInPlaylist({required int playlistId}) async {
    final List<Map<String, dynamic>> videoMaps = await _db.rawQuery('''
      SELECT Video.* FROM Video
      INNER JOIN PlaylistVideo ON Video.id = PlaylistVideo.videoId
      WHERE PlaylistVideo.playlistId = ?
    ''', [playlistId]);

    final List<Future<Video?>> futures = videoMaps.map((videoMap) async {
      final videoModel = VideoModel.fromJson(json: videoMap);
      final videoId = videoModel.id;
      if (videoId == null) return null;

      final videoInfoFutures = _db.query(
        'VideoInfo',
        where: 'videoId = ?',
        whereArgs: [videoId],
      );

      final audioInfoFutures = _db.query(
        'AudioInfo',
        where: 'videoId = ? AND audioId IS NULL',
        whereArgs: [videoId],
      );

      final results = await Future.wait([videoInfoFutures, audioInfoFutures]);
      final videoInfoMaps = results[0];
      final audioInfoMaps = results[1];

      if (videoInfoMaps.isEmpty || audioInfoMaps.isEmpty) {
        return null;
      }

      final videoInfoModel = VideoInfoModel.fromJson(json: videoInfoMaps.first);
      final audioInfoModel = AudioInfoModel.fromJson(json: audioInfoMaps.first);

      return videoModel.toVideo(
        audioInfoModel: audioInfoModel,
        videoInfoModel: videoInfoModel,
      );
    }).toList();

    final List<Video?> resolvedVideos = await Future.wait(futures);
    return resolvedVideos.whereType<Video>().toList();
  }

  @override
  Future<void> updateVideoMeta({required Video video}) async {
    final videoId = video.id;
    if (videoId == null) return;

    await _db.transaction((txn) async {
      VideoModel videoModel = VideoModel.fromVideo(video: video);
      final videoJson = videoModel.toJson()..remove('id');
      await txn.update(
        'Video',
        videoJson,
        where: 'id = ?',
        whereArgs: [videoId],
      );

      final videoInfoModel = VideoInfoModel.fromVideoInfo(
        videoInfo: video.videoInfo,
        videoId: videoId,
      );
      final videoInfoJson = videoInfoModel.toJson()..remove('id');
      await txn.update(
        'VideoInfo',
        videoInfoJson,
        where: 'videoId = ?',
        whereArgs: [videoId],
      );

      final audioInfoModel = AudioInfoModel.fromAudioInfo(
        audioInfo: video.audioInfo,
        videoId: videoId,
      );
      final audioInfoJson = audioInfoModel.toJson()..remove('id');
      await txn.update(
        'AudioInfo',
        audioInfoJson,
        where: 'videoId = ? AND audioId IS NULL',
        whereArgs: [videoId],
      );
    });
  }
}
