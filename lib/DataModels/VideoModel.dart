import 'dart:typed_data';

class VideoModel {
  final int? id;
  final String filePath;
  final Uint8List? thumbnail;
  final bool isFavorite;
  final int length;
  final int resumeTimeStamp;
  final DateTime? lastPlayedAt;

  const VideoModel({
    this.id,
    this.lastPlayedAt,
    this.thumbnail,
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
      'resumeTimeStamp': this.resumeTimeStamp,
      'lastPlayedAt': this.lastPlayedAt?.millisecondsSinceEpoch,
    };
  }

  factory VideoModel.fromJson({required Map<String, dynamic> json}) {
    return VideoModel(
      id: json['id'],
      lastPlayedAt: (json['lastPlayedAt'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPlayedAt'])
          : null,
      filePath: json['filePath'],
      isFavorite: (json['isFavorite'] == 1) ? true : false,
      thumbnail: json['thumbnail'],
      length: json['length'],
      resumeTimeStamp: json['resumeTimeStamp'],
    );
  }

  VideoModel copyWith({
    required int? id,
    required DateTime? lastPlayedAt,
    bool? isFavorite,
    String? filePath,
    required Uint8List? thumbnail,
    int? length,
    int? resumeTimeStamp,
  }) {
    return VideoModel(
      id: id,
      isFavorite: isFavorite ?? this.isFavorite,
      lastPlayedAt: lastPlayedAt,
      filePath: filePath ?? this.filePath,
      thumbnail: thumbnail,
      length: length ?? this.length,
      resumeTimeStamp: resumeTimeStamp ?? this.resumeTimeStamp,
    );
  }
}
