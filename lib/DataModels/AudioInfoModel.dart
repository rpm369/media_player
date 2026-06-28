import 'package:media_player/DomainModels/AudioInfo.dart';

class AudioInfoModel {
  final int? id;
  final int? videoId;
  final int? audioId;

  final int bitRate;
  final String codec;
  final String language;
  final int channelCount;
  final int sampleRate;

  const AudioInfoModel({
    this.id,
    this.videoId,
    this.audioId,
    required this.bitRate,
    required this.codec,
    required this.language,
    required this.channelCount,
    required this.sampleRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'videoId': this.videoId,
      'audioId': this.audioId,
      'bitRate': this.bitRate,
      'codec': this.codec,
      'language': this.language,
      'channelCount': this.channelCount,
      'sampleRate': this.sampleRate,
    };
  }

  AudioInfo toAudioInfo() {
    return AudioInfo(
      id: this.id,
      bitRate: this.bitRate,
      codec: this.codec,
      language: this.language,
      channelCount: this.channelCount,
      sampleRate: this.sampleRate,
    );
  }

  factory AudioInfoModel.fromAudioInfo({
    required AudioInfo audioInfo,
    int? audioId,
    int? videoId,
  }) {
    if ((audioId != null && videoId != null ||
        audioId == null && videoId == null))
      throw Exception("Either VideId or AudioId could be null at a time.");

    return AudioInfoModel(
      id: audioInfo.id,
      audioId: audioId,
      videoId: videoId,
      bitRate: audioInfo.bitRate,
      codec: audioInfo.codec,
      language: audioInfo.language,
      channelCount: audioInfo.channelCount,
      sampleRate: audioInfo.sampleRate,
    );
  }

  factory AudioInfoModel.fromJson({required Map<String, dynamic> json}) {
    return AudioInfoModel(
      id: json['id'],
      audioId: json['audioId'],
      videoId: json['videoId'],
      bitRate: json['bitRate'],
      codec: json['codec'],
      language: json['language'],
      channelCount: json['channelCount'],
      sampleRate: json['sampleRate'],
    );
  }

  AudioInfoModel copyWith({
    required int? id,
    required int? videoId,
    required int? audioId,
    int? bitRate,
    String? codec,
    String? language,
    int? channelCount,
    int? sampleRate,
  }) {
    return AudioInfoModel(
      id: id,
      videoId: videoId,
      audioId: audioId,
      bitRate: bitRate ?? this.bitRate,
      codec: codec ?? this.codec,
      language: language ?? this.language,
      channelCount: channelCount ?? this.channelCount,
      sampleRate: sampleRate ?? this.sampleRate,
    );
  }
}
