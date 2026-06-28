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
  final bool hasFinished;
  final DateTime? lastPlayedAt;
  final VideoInfo videoInfo;
  final AudioInfo audioInfo;

  const Video({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
    required this.audioInfo,
    required this.videoInfo,
    required this.hasFinished,
    required this.isFavorite,
    required this.filePath,
    required this.length,
    required this.resumeTimeStamp,
  });

  Video copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    required Uint8List? thumbnail,
    bool? hasFinished,
    VideoInfo? videoInfo,
    AudioInfo? audioInfo,
    bool? isFavorite,
    String? filePath,
    Duration? length,
    Duration? resumeTimeStamp,
  }) {
    return Video(
      id: id,
      audioInfo: audioInfo ?? this.audioInfo,
      videoInfo: videoInfo ?? this.videoInfo,
      lastPlayedAt: lastPlayedAt,
      thumbnail: thumbnail,
      hasFinished: hasFinished ?? this.hasFinished,
      isFavorite: isFavorite ?? this.isFavorite,
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
    );
  }
}
