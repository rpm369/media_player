import 'dart:typed_data';

import 'package:media_player/DomainModels/Audio.dart';
import 'package:media_player/DomainModels/AudioInfo.dart';

class AudioModel {
  final int? id;
  final String filePath;
  final int length;
  final int sizeInBytes;
  final int resumeTimeStamp;
  final DateTime? lastPlayedAt;
  final bool isFavorite;
  final Uint8List? thumbnail;

  const AudioModel({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
    required this.sizeInBytes,
    required this.filePath,
    required this.length,
    required this.resumeTimeStamp,
    required this.isFavorite,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'filePath': this.filePath,
      'length': this.length,
      'sizeInBytes': this.sizeInBytes,
      'resumeTimeStamp': this.resumeTimeStamp,
      'isFavorite': (this.isFavorite) ? 1 : 0,
      'thumbnail': this.thumbnail,
      'lastPlayedAt': this.lastPlayedAt?.millisecondsSinceEpoch,
    };
  }

  Audio toAudio({required AudioInfo audioInfo}) {
    Duration audioLength = Duration(milliseconds: this.length);
    Duration resumeTimeStamp = Duration(milliseconds: this.resumeTimeStamp);

    return Audio(
      id: this.id,
      audioInfo: audioInfo,
      lastPlayedAt: this.lastPlayedAt,
      thumbnail: this.thumbnail,
      sizeInBytes: this.sizeInBytes,
      filePath: this.filePath,
      length: audioLength,
      resumeTimeStamp: resumeTimeStamp,
      isFavorite: this.isFavorite,
    );
  }

  factory AudioModel.fromAudio({required Audio audio}) {
    return AudioModel(
      id: audio.id,
      lastPlayedAt: audio.lastPlayedAt,
      thumbnail: audio.thumbnail,
      sizeInBytes: audio.sizeInBytes,
      filePath: audio.filePath,
      length: audio.length.inMilliseconds,
      resumeTimeStamp: audio.resumeTimeStamp.inMilliseconds,
      isFavorite: audio.isFavorite,
    );
  }

  factory AudioModel.fromJson({required Map<String, dynamic> json}) {
    return AudioModel(
      id: json['id'],
      filePath: json['filePath'],
      length: json['length'],
      sizeInBytes: json['sizeInBytes'],
      resumeTimeStamp: json['resumeTimeStamp'],
      isFavorite: (json['isFavorite'] == 1),
      lastPlayedAt: (json['lastPlayedAt'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['lastPlayedAt']),
      thumbnail: json['thumbnail'],
    );
  }

  AudioModel copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    required Uint8List? thumbnail,
    String? filePath,
    int? sizeInBytes,
    int? length,
    int? resumeTimeStamp,
    bool? isFavorite,
  }) {
    return AudioModel(
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
      isFavorite: isFavorite ?? this.isFavorite,
      id: id,
      lastPlayedAt: lastPlayedAt,
      thumbnail: thumbnail,
    );
  }
}
