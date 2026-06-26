import 'Audio.dart';
import 'Video.dart';

class Playlist {
  final int? id;
  final String name;
  final List<Audio> audios;
  final List<Video> videos;

  const Playlist({
    this.id,
    required this.name,
    this.audios = const [],
    this.videos = const [],
  });

  Playlist copyWith({
    required int? id,
    String? name,
    List<Audio>? audios,
    List<Video>? videos,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      audios: audios ?? this.audios,
      videos: videos ?? this.videos,
    );
  }
}
