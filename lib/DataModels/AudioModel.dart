import 'dart:typed_data';

class AudioModel {
  final int? id;
  final String filePath;
  final int length;
  final int resumeTimeStamp;
  final DateTime? lastPlayedAt;
  final bool isFavorite;
  final Uint8List? thumbnail;

  const AudioModel({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
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
      'resumeTimeStamp': this.resumeTimeStamp,
      'isFavorite': (this.isFavorite) ? 1 : 0,
      'thumbnail': this.thumbnail,
      'lastPlayedAt': this.lastPlayedAt?.millisecondsSinceEpoch,
    };
  }

  factory AudioModel.fromJson({required Map<String, dynamic> json}) {
    return AudioModel(
      id: json['id'],
      filePath: json['filePath'],
      length: json['length'],
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
    int? length,
    int? resumeTimeStamp,
    bool? isFavorite,
  }) {
    return AudioModel(
      filePath: filePath ?? this.filePath,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
      isFavorite: isFavorite ?? this.isFavorite,
      id: id,
      lastPlayedAt: lastPlayedAt,
      thumbnail: thumbnail,
    );
  }
}
