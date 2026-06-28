import 'package:media_player/DomainModels/Video.dart';

abstract class VideoRepository {
  Future<int> createVideoMeta({required Video video});
  Future<List<Video>> getAllVideosMeta();
  Future<void> updateVideoMeta({required Video video});
  Future<void> deleteVideoMeta({required int videoId});
}
