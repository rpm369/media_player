import 'dart:io';
import 'dart:typed_data';

import 'package:media_player/DomainModels/AudioInfo.dart';
import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/DomainModels/VideoInfo.dart';
import 'package:media_player/Repos/VideoRepo.dart';
import 'package:media_player/Utils/FileTypeUtil.dart';
import 'package:media_player/Utils/PermissionHandler.dart';
import 'package:media_player/Utils/MediaMetaUtils.dart';

class VideoService {
  final VideoRepository _repo;
  const VideoService({required this._repo});

  Future<List<Video>> getAllVideoForPlaylist({required int playlistId}) async {
    return await _repo.getAllVideosInPlaylist(playlistId: playlistId);
  }

  Future<List<Video>> loadVideos() async {
    List<Video> allVideoMeta = await _repo.getAllVideosMeta();

    Set<String> videoPathInDb = allVideoMeta
        .map((video) => video.filePath)
        .toSet();

    Set<String> videoPathOnDisk = {};

    bool isGranted = await PermissionHandler.handleDiskAcessPermissions();
    if (!isGranted) throw Exception("Disk read permissions are not enabled");

    Directory root = Directory('/storage/emulated/0/');

    await for (FileSystemEntity file in root.list(recursive: true)) {
      if (FileTypeUtil.isVideo(file: file)) videoPathOnDisk.add(file.path);
    }

    Set<String> videoMetaToBeRemoved = videoPathInDb.difference(
      videoPathOnDisk,
    );
    Set<String> videoMetaToBeAdded = videoPathOnDisk.difference(videoPathInDb);

    for (String videoPath in videoMetaToBeRemoved) {
      await _repo.deleteVideoMetaByPath(path: videoPath);
      allVideoMeta.removeWhere((video) => video.filePath == videoPath);
    }

    for (String videoPath in videoMetaToBeAdded) {
      Video video = await createVideoMetaByPath(path: videoPath);
      int videoId = await _repo.createVideoMeta(video: video);
      video = video.copyWith(
        id: videoId,
        lastPlayedAt: video.lastPlayedAt,
        thumbnail: video.thumbnail,
      );
      allVideoMeta.add(video);
    }

    return allVideoMeta;
  }

  Future<Video> createVideoMetaByPath({required String path}) async {
    Uint8List? thumbnail = await MediaMetaUtils.extractVideoThumbnail(
      path: path,
    );
    VideoInfo videoInfo = await MediaMetaUtils.extractVideoInfo(path: path);
    AudioInfo audioInfo = await MediaMetaUtils.extractAudioInfo(path: path);
    Duration videoLength = await MediaMetaUtils.getMediaLength(path: path);
    int sizeInBytes = await MediaMetaUtils.getMediaSizeInBytes(mediaPath: path);

    return Video(
      sizeInBytes: sizeInBytes,
      thumbnail: thumbnail,
      audioInfo: audioInfo,
      videoInfo: videoInfo,
      hasFinished: false,
      isFavorite: false,
      filePath: path,
      length: videoLength,
      resumeTimeStamp: Duration(milliseconds: 0),
    );
  }

  Future<void> toggleFinishStatus({required Video video}) async {
    video = video.copyWith(
      id: video.id,
      lastPlayedAt: video.lastPlayedAt,
      thumbnail: video.thumbnail,
      hasFinished: !video.hasFinished,
    );
    await _repo.updateVideoMeta(video: video);
  }

  Future<void> updateResumeTimeStamp({
    required Video video,
    required Duration newTimeStamp,
  }) async {
    video = video.copyWith(
      id: video.id,
      lastPlayedAt: video.lastPlayedAt,
      thumbnail: video.thumbnail,
      resumeTimeStamp: newTimeStamp,
    );
    await _repo.updateVideoMeta(video: video);
  }

  Future<void> toggleFavoriteStatus({required Video video}) async {
    video = video.copyWith(
      id: video.id,
      lastPlayedAt: video.lastPlayedAt,
      thumbnail: video.thumbnail,
      isFavorite: !video.isFavorite,
    );
    await _repo.updateVideoMeta(video: video);
  }

  Future<void> addToPlaylist({
    required Video video,
    required Playlist playlist,
  }) async {
    await _repo.addVideoToPlaylist(
      videoId: video.id!,
      playlistId: playlist.id!,
    );
  }

  Future<void> deleteVideo({required Video video}) async {
    await _repo.deleteVideoMetaById(videoId: video.id!);
  }

  Future<void> renameVideo({
    required Video video,
    required String newName,
  }) async {
    String newPath = await MediaMetaUtils.changeMediaName(
      filePath: video.filePath,
      newName: newName,
    );

    video = video.copyWith(
      id: video.id,
      lastPlayedAt: video.lastPlayedAt,
      thumbnail: video.thumbnail,
      filePath: newPath,
    );

    await _repo.updateVideoMeta(video: video);
  }

  Future<void> updateLastPlayedDate({required Video video}) async {
    video = video.copyWith(
      id: video.id,
      lastPlayedAt: DateTime.now(),
      thumbnail: video.thumbnail,
    );
    await _repo.updateVideoMeta(video: video);
  }
}
