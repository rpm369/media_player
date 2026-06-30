import 'dart:io';
import 'dart:typed_data';

import 'package:media_player/DomainModels/Audio.dart';
import 'package:media_player/DomainModels/AudioInfo.dart';
import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/Repos/AudioRepo.dart';
import 'package:media_player/Utils/FileTypeUtil.dart';
import 'package:media_player/Utils/MediaMetaUtils.dart';
import 'package:media_player/Utils/PermissionHandler.dart';

class AudioService {
  AudioRepository _repo;
  AudioService({required this._repo});

  Future<List<Audio>> getAllAudioForPlaylist({required int playlistId}) async {
    return await _repo.getAllAudioInPlaylist(playlistId: playlistId);
  }

  Future<List<Audio>> loadAllAudio() async {
    List<Audio> allAudioMeta = await _repo.getAllAudioMeta();

    Set<String> audioPathInDb = allAudioMeta
        .map((audio) => audio.filePath)
        .toSet();

    Set<String> audioPathOnDisk = {};

    bool isGranted = await PermissionHandler.handleDiskAcessPermissions();
    if (!isGranted) throw Exception("Disk read permissions are not enabled");

    Directory root = Directory('/storage/emulated/0/');

    await for (FileSystemEntity file in root.list(recursive: true)) {
      if (FileTypeUtil.isAudio(file: file)) audioPathOnDisk.add(file.path);
    }

    Set<String> audioMetaToBeRemoved = audioPathInDb.difference(
      audioPathOnDisk,
    );
    Set<String> audioMetaToBeAdded = audioPathOnDisk.difference(audioPathInDb);

    for (String audioPath in audioMetaToBeRemoved) {
      await _repo.deleteAudioMetaByPath(path: audioPath);
      allAudioMeta.removeWhere((audio) => audio.filePath == audioPath);
    }

    for (String audioPath in audioMetaToBeAdded) {
      Audio audio = await createAudioMetaByPath(path: audioPath);
      int audioId = await _repo.createAudioMeta(audio: audio);
      audio = audio.copyWith(
        id: audioId,
        lastPlayedAt: audio.lastPlayedAt,
        thumbnail: audio.thumbnail,
      );
      allAudioMeta.add(audio);
    }

    return allAudioMeta;
  }

  Future<Audio> createAudioMetaByPath({required String path}) async {
    Uint8List? albumCover = await MediaMetaUtils.extractAudioAlbumCover(
      path: path,
    );
    Duration audioLength = await MediaMetaUtils.getMediaLength(path: path);
    AudioInfo audioInfo = await MediaMetaUtils.extractAudioInfo(path: path);
    int audioSize = await MediaMetaUtils.getMediaSizeInBytes(mediaPath: path);

    return Audio(
      thumbnail: albumCover,
      sizeInBytes: audioSize,
      audioInfo: audioInfo,
      filePath: path,
      length: audioLength,
      resumeTimeStamp: Duration(milliseconds: 0),
      isFavorite: false,
    );
  }

  Future<void> addToPlaylist({
    required Audio audio,
    required Playlist playlist,
  }) async {
    await _repo.addAudioToPlaylist(
      audioId: audio.id!,
      playlistId: playlist.id!,
    );
  }

  Future<void> toggletFavoriteStatus({required Audio audio}) async {
    audio = audio.copyWith(
      id: audio.id,
      lastPlayedAt: audio.lastPlayedAt,
      thumbnail: audio.thumbnail,
      isFavorite: !audio.isFavorite,
    );
    await _repo.updateAudioMeta(audio: audio);
  }

  Future<void> deleteAudio({required Audio audio}) async {
    await _repo.deleteAudioMetaById(id: audio.id!);
  }

  Future<void> renameAudio({
    required Audio audio,
    required String newName,
  }) async {
    String newPath = await MediaMetaUtils.changeMediaName(
      filePath: audio.filePath,
      newName: newName,
    );
    audio = audio.copyWith(
      id: audio.id,
      lastPlayedAt: audio.lastPlayedAt,
      thumbnail: audio.thumbnail,
      filePath: newPath,
    );
    await _repo.updateAudioMeta(audio: audio);
  }

  Future<void> updateLastPlayedDate({required Audio audio}) async {
    audio = audio.copyWith(
      id: audio.id,
      lastPlayedAt: DateTime.now(),
      thumbnail: audio.thumbnail,
    );
    await _repo.updateAudioMeta(audio: audio);
  }
}
