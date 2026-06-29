import 'package:media_player/DomainModels/Video.dart';

abstract class VideoRepository {
  Future<int> createVideoMeta({required Video video});
  Future<void> addVideoToPlaylist({
    required int videoId,
    required int playlistId,
  });
  Future<List<Video>> getAllVideosMeta();
  Future<List<Video>> getAllVideosInPlaylist({required int playlistId});
  Future<void> updateVideoMeta({required Video video});
  Future<void> deleteVideoMetaById({required int videoId});
  Future<void> deleteVideoMetaByPath({required String path});
}
