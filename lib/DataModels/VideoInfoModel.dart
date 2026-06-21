class VideoInfoModel {
  final int? id;
  final int? videoId;
  final String codec;
  final String language;
  final String resolution;
  final double frameRate;

  VideoInfoModel({
    this.id,
    this.videoId,
    required this.codec,
    required this.language,
    required this.resolution,
    required this.frameRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'videoId': this.videoId,
      'codec': this.codec,
      'language': this.language,
      'resolution': this.resolution,
      'frameRate': this.frameRate,
    };
  }

  factory VideoInfoModel.fromJson({required Map<String, dynamic> json}) {
    return VideoInfoModel(
      id: json['id'],
      videoId: json['videoId'],
      codec: json['codec'],
      language: json['language'],
      resolution: json['resolution'],
      frameRate: json['frameRate'],
    );
  }

  VideoInfoModel copyWith({
    required int? id,
    required int? videoId,
    String? codec,
    String? language,
    String? resolution,
    double? frameRate,
  }) {
    return VideoInfoModel(
      id: id,
      videoId: videoId,
      codec: codec ?? this.codec,
      language: language ?? this.language,
      resolution: resolution ?? this.resolution,
      frameRate: frameRate ?? this.frameRate,
    );
  }
}
