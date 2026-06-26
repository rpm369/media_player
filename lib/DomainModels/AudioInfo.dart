class AudioInfo {
  final int? id;
  final int bitRate;
  final String codec;
  final String language;
  final int channelCount;
  final int sampleRate;

  const AudioInfo({
    this.id,
    required this.bitRate,
    required this.codec,
    required this.language,
    required this.channelCount,
    required this.sampleRate,
  });

  AudioInfo copyWith({
    required int? id,
    int? bitRate,
    String? codec,
    String? language,
    int? channelCount,
    int? sampleRate,
  }) {
    return AudioInfo(
      id: id,
      bitRate: bitRate ?? this.bitRate,
      codec: codec ?? this.codec,
      language: language ?? this.language,
      channelCount: channelCount ?? this.channelCount,
      sampleRate: sampleRate ?? this.sampleRate,
    );
  }
}
