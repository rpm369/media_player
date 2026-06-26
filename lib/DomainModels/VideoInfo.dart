class VideoInfo {
  final int? id;
  final String codec;
  final String language;
  final String resolution;
  final double frameRate;

  const VideoInfo({
    this.id,
    required this.codec,
    required this.language,
    required this.resolution,
    required this.frameRate,
  });

  VideoInfo copyWith({
    required int? id,
    String? codec,
    String? language,
    String? resolution,
    double? frameRate,
  }) {
    return VideoInfo(
      id: id,
      codec: codec ?? this.codec,
      language: language ?? this.language,
      resolution: resolution ?? this.resolution,
      frameRate: frameRate ?? this.frameRate,
    );
  }
}
