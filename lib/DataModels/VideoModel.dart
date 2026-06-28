import 'dart:typed_data';

import 'package:media_player/DataModels/AudioInfoModel.dart';
import 'package:media_player/DataModels/VideoInfoModel.dart';
import 'package:media_player/DomainModels/AudioInfo.dart';
import 'package:media_player/DomainModels/Video.dart';

class VideoModel {
  final int? id;
  final String filePath;
  final Uint8List? thumbnail;
  final bool isFavorite;
  final int length;
  final bool hasFinished;
  final int resumeTimeStamp;
  final DateTime? lastPlayedAt;

  const VideoModel({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
    required this.hasFinished,
    required this.isFavorite,
    required this.filePath,
    required this.length,
    required this.resumeTimeStamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'filePath': this.filePath,
      'thumbnail': this.thumbnail,
      'length': this.length,
      'isFavorite': (this.isFavorite) ? 1 : 0,
      'hasFinished': (this.hasFinished) ? 1 : 0,
      'resumeTimeStamp': this.resumeTimeStamp,
      'lastPlayedAt': this.lastPlayedAt?.millisecondsSinceEpoch,
    };
  }

  Video toVideo({
    required AudioInfoModel audioInfoModel,
    required VideoInfoModel videoInfoModel,
  }) {
    return Video(
      id: this.id,
      audioInfo: audioInfoModel.toAudioInfo(),
      videoInfo: videoInfoModel.toVideoInfo(),
      lastPlayedAt: this.lastPlayedAt,
      thumbnail: this.thumbnail,
      hasFinished: this.hasFinished,
      isFavorite: this.isFavorite,
      filePath: this.filePath,
      length: Duration(milliseconds: this.length),
      resumeTimeStamp: Duration(milliseconds: this.resumeTimeStamp),
    );
  }

  factory VideoModel.fromJson({required Map<String, dynamic> json}) {
    return VideoModel(
      id: json['id'],
      lastPlayedAt: (json['lastPlayedAt'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPlayedAt'])
          : null,
      hasFinished: (json['hasFinished'] == 1),
      filePath: json['filePath'],
      isFavorite: (json['isFavorite'] == 1),
      thumbnail: json['thumbnail'],
      length: json['length'],
      resumeTimeStamp: json['resumeTimeStamp'],
    );
  }

  factory VideoModel.fromVideo({required Video video}) {
    int videoLength = video.length.inMilliseconds;
    int resumeTimeStamp = video.resumeTimeStamp.inMilliseconds;

    return VideoModel(
      id: video.id,
      lastPlayedAt: video.lastPlayedAt,
      thumbnail: video.thumbnail,
      hasFinished: video.hasFinished,
      isFavorite: video.isFavorite,
      filePath: video.filePath,
      length: videoLength,
      resumeTimeStamp: resumeTimeStamp,
    );
  }

  VideoModel copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    bool? isFavorite,
    String? filePath,
    bool? hasFinished,
    required Uint8List? thumbnail,
    int? length,
    int? resumeTimeStamp,
  }) {
    return VideoModel(
      id: id,
      isFavorite: isFavorite ?? this.isFavorite,
      lastPlayedAt: lastPlayedAt,
      filePath: filePath ?? this.filePath,
      hasFinished: hasFinished ?? this.hasFinished,
      thumbnail: thumbnail,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
    );
  }
}
