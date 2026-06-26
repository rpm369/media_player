import 'dart:typed_data';
import 'VideoInfo.dart';
import 'AudioInfo.dart';

class Video {
  final int? id;
  final String filePath;
  final Uint8List? thumbnail;
  final bool isFavorite;
  final Duration length;
  final Duration resumeTimeStamp;
  final DateTime? lastPlayedAt;
  final VideoInfo? videoInfo;
  final AudioInfo? audioTracks;

  const Video({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
    this.videoInfo,
    this.audioTracks,
    required this.isFavorite,
    required this.filePath,
    required this.length,
    required this.resumeTimeStamp,
  });

  Video copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    required Uint8List? thumbnail,
    VideoInfo? videoInfo,
    AudioInfo? audioInfo,
    bool? isFavorite,
    String? filePath,
    Duration? length,
    Duration? resumeTimeStamp,
  }) {
    return Video(
      id: id,
      lastPlayedAt: lastPlayedAt,
      thumbnail: thumbnail,
      videoInfo: videoInfo ?? this.videoInfo,
      audioTracks: audioTracks ?? this.audioTracks,
      isFavorite: isFavorite ?? this.isFavorite,
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
    );
  }
}
