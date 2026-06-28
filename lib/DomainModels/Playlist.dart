import 'dart:typed_data';

import 'Audio.dart';
import 'Video.dart';

class Playlist {
  final int? id;
  final String name;
  final bool isFavorite;
  final List<Audio> audios;
  final List<Video> videos;

  const Playlist({
    this.id,
    required this.name,
    required this.isFavorite,
    this.audios = const [],
    this.videos = const [],
  });

  Playlist copyWith({
    required int? id,
    String? name,
    bool? isFavorite,
    List<Audio>? audios,
    List<Video>? videos,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
      audios: audios ?? this.audios,
      videos: videos ?? this.videos,
    );
  }
}
