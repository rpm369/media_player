import 'package:media_player/DomainModels/Audio.dart';
import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/Repos/PlaylistRepo.dart';
import 'package:media_player/Services/AudioService.dart';
import 'package:media_player/Services/VideoService.dart';

class PlaylistService {
  final PlaylistRepository _repo;
  final AudioService _audioService;
  final VideoService _videoService;

  const PlaylistService({
    required this._repo,
    required this._audioService,
    required this._videoService,
  });

  Future<List<Playlist>> getAllPlaylists() async {
    List<Playlist> allEmptyPlaylist = await _repo.getAllPlaylist();
    List<Playlist> allFilledPlaylist = [];

    for (Playlist playlist in allEmptyPlaylist) {
      List<Audio> audios = await _audioService.getAllAudioForPlaylist(
        playlistId: playlist.id!,
      );
      List<Video> videos = await _videoService.getAllVideoForPlaylist(
        playlistId: playlist.id!,
      );
      playlist = playlist.copyWith(
        id: playlist.id!,
        audios: audios,
        videos: videos,
      );
      allFilledPlaylist.add(playlist);
    }

    return allFilledPlaylist;
  }

  Future<void> rename({
    required Playlist playlist,
    required String newName,
  }) async {
    playlist = playlist.copyWith(id: playlist.id, name: newName);
    await _repo.updatePlaylist(playlist: playlist);
  }

  Future<void> delete({required Playlist playlist}) async {
    await _repo.deletePlaylist(id: playlist.id!);
  }

  Future<void> toggleFavoriteStatus({required Playlist playlist}) async {
    playlist = playlist.copyWith(
      id: playlist.id!,
      isFavorite: !playlist.isFavorite,
    );
    await _repo.updatePlaylist(playlist: playlist);
  }
}
