import 'dart:typed_data';
import 'AudioInfo.dart';

class Audio {
  final int? id;
  final String filePath;
  final Duration length;
  final Duration resumeTimeStamp;
  final DateTime? lastPlayedAt;
  final bool isFavorite;
  final Uint8List? thumbnail;
  final AudioInfo? audioInfo;

  const Audio({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
    this.audioInfo,
    required this.filePath,
    required this.length,
    required this.resumeTimeStamp,
    required this.isFavorite,
  });

  Audio copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    required Uint8List? thumbnail,
    required AudioInfo? audioInfo,
    String? filePath,
    Duration? length,
    Duration? resumeTimeStamp,
    bool? isFavorite,
  }) {
    return Audio(
      id: id,
      lastPlayedAt: lastPlayedAt,
      thumbnail: thumbnail,
      audioInfo: audioInfo,
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
