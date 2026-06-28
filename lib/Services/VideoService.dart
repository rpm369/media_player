import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/Repos/VideoRepo.dart';

class VideoService {
  final VideoRepository _repo;
  const VideoService({required this._repo});

  Future<List<Video>> loadVideos() async {}
  Future<void> toggleFinishStatus({required Video video}) async {}
  Future<void> updateResumeTimeStamp({
    required Video video,
    required Duration newTimeStamp,
  }) async {}
  Future<void> toggleFavoriteStatus({required Video video}) async {}
  Future<void> addToPlaylist({
    required Video video,
    required Playlist playlist,
  }) async {}
  Future<void> deleteVideo({required Video video}) async {}
  Future<void> renameVideo({
    required Video video,
    required String newName,
  }) async {}
}
