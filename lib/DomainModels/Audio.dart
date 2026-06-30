import 'dart:typed_data';
import 'package:media_player/Utils/PathUtils.dart';

import 'AudioInfo.dart';

class Audio {
  final int? id;
  final String filePath;
  final int sizeInBytes;
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
    required this.sizeInBytes,
    required this.filePath,
    required this.length,
    required this.resumeTimeStamp,
    required this.isFavorite,
  });

  String get fileName =>
      PathUtils.getFileNameWithoutExtension(path: this.filePath);

  Audio copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    required Uint8List? thumbnail,
    int? sizeInBytes,
    AudioInfo? audioInfo,
    String? filePath,
    Duration? length,
    Duration? resumeTimeStamp,
    bool? isFavorite,
  }) {
    return Audio(
      id: id,
      lastPlayedAt: lastPlayedAt,
      thumbnail: thumbnail,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      audioInfo: audioInfo ?? this.audioInfo,
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
