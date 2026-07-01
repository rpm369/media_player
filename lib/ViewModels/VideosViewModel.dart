import 'package:flutter/material.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/DomainModels/Playlist.dart';
import 'package:media_player/Services/PlaylistService.dart';
import 'package:media_player/Services/VideoService.dart';

class VideosViewModel extends ChangeNotifier {
  final VideoService _videoService;
  final PlaylistService _playlistService;

  List<Video> _videos = [];
  List<Video> _filteredVideos = [];
  Video? _lastPlayed = null;
  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  bool _isSearching = false;

  List<Playlist> _playlists = [];
  bool _playlistsLoading = false;

  VideosViewModel({
    required VideoService videoService,
    required PlaylistService playlistService,
  }) : _videoService = videoService,
       _playlistService = playlistService;

  // Getters
  List<Video> get videos => _filteredVideos;
  List<Video> get allVideos => _videos;
  bool get isLoading => _isLoading;
  Video? get lastPlayed => _lastPlayed;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  List<Playlist> get playlists => _playlists;
  bool get playlistsLoading => _playlistsLoading;

  // Load videos
  Future<void> loadVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _videos = await _videoService.loadVideos();
      _lastPlayed = _extractLastPlayed(videos: _videos);
      _filterVideos();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Video? _extractLastPlayed({required List<Video> videos}) {
    Video? lastPlayedVideo;

    if (videos.isNotEmpty) lastPlayedVideo = videos.first;

    for (Video video in videos) {
      if (video.lastPlayedAt == null) continue;
      if (lastPlayedVideo!.lastPlayedAt == null) lastPlayedVideo = video;

      bool isLastPlayed = video.lastPlayedAt!.isAfter(
        lastPlayedVideo.lastPlayedAt!,
      );

      if (isLastPlayed) {
        lastPlayedVideo = video;
      }
    }

    return lastPlayedVideo;
  }

  // Filter helper
  void _filterVideos() {
    if (_searchQuery.isEmpty) {
      _filteredVideos = List.from(_videos);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredVideos = _videos.where((video) {
        return video.fileName.toLowerCase().contains(query) ||
            video.filePath.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Search functionality
  void startSearch() {
    _isSearching = true;
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    _searchQuery = '';
    _filterVideos();
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterVideos();
    notifyListeners();
  }

  // Playback Operations
  Future<void> playVideo(Video video) async {
    try {
      await _videoService.updateLastPlayedDate(video: video);
      _lastPlayed = video;

      final index = _videos.indexWhere((v) => v.id == video.id);
      if (index != -1) {
        _videos[index] = _videos[index].copyWith(
          id: _videos[index].id,
          lastPlayedAt: DateTime.now(),
          thumbnail: _videos[index].thumbnail,
        );
        _filterVideos();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to play video: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> playFromStart(Video video) async {
    try {
      await _videoService.updateResumeTimeStamp(
        video: video,
        newTimeStamp: Duration.zero,
      );
      if (video.hasFinished) {
        await _videoService.toggleFinishStatus(video: video);
      }
      await _videoService.updateLastPlayedDate(video: video);

      _lastPlayed = video;

      final index = _videos.indexWhere((v) => v.id == video.id);
      if (index != -1) {
        _videos[index] = _videos[index].copyWith(
          id: _videos[index].id,
          lastPlayedAt: DateTime.now(),
          thumbnail: _videos[index].thumbnail,
          resumeTimeStamp: Duration.zero,
          hasFinished: false,
        );
        _filterVideos();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to play from start: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> playAll() async {
    if (_filteredVideos.isNotEmpty) {
      await playVideo(_filteredVideos.first);
    }
  }

  // Favorite Operation
  Future<void> toggleFavoriteStatus(Video video) async {
    try {
      await _videoService.toggleFavoriteStatus(video: video);

      final index = _videos.indexWhere((v) => v.id == video.id);
      if (index != -1) {
        _videos[index] = _videos[index].copyWith(
          id: _videos[index].id,
          lastPlayedAt: _videos[index].lastPlayedAt,
          thumbnail: _videos[index].thumbnail,
          isFavorite: !_videos[index].isFavorite,
        );
        _filterVideos();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle favorite status: ${e.toString()}';
      notifyListeners();
    }
  }

  // Delete Operation
  Future<void> deleteVideo(Video video) async {
    try {
      await _videoService.deleteVideo(video: video);

      _videos.removeWhere((v) => v.id == video.id);
      _filterVideos();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete video: ${e.toString()}';
      notifyListeners();
    }
  }

  // Mark as Played / Not Played Operations
  Future<void> markAsPlayed(Video video) async {
    try {
      if (!video.hasFinished) {
        await _videoService.toggleFinishStatus(video: video);
        await _videoService.updateResumeTimeStamp(
          video: video,
          newTimeStamp: Duration.zero,
        );

        final index = _videos.indexWhere((v) => v.id == video.id);
        if (index != -1) {
          _videos[index] = _videos[index].copyWith(
            id: _videos[index].id,
            lastPlayedAt: _videos[index].lastPlayedAt,
            thumbnail: _videos[index].thumbnail,
            resumeTimeStamp: Duration.zero,
            hasFinished: true,
          );
          _filterVideos();
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to mark as played: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> markAsNotPlayed(Video video) async {
    try {
      bool changed = false;
      Video updatedVideo = video;

      if (updatedVideo.hasFinished) {
        await _videoService.toggleFinishStatus(video: updatedVideo);
        updatedVideo = updatedVideo.copyWith(
          id: updatedVideo.id,
          lastPlayedAt: updatedVideo.lastPlayedAt,
          thumbnail: updatedVideo.thumbnail,
          hasFinished: false,
        );
        changed = true;
      }

      if (updatedVideo.resumeTimeStamp != Duration.zero) {
        await _videoService.updateResumeTimeStamp(
          video: updatedVideo,
          newTimeStamp: Duration.zero,
        );
        updatedVideo = updatedVideo.copyWith(
          id: updatedVideo.id,
          lastPlayedAt: updatedVideo.lastPlayedAt,
          thumbnail: updatedVideo.thumbnail,
          resumeTimeStamp: Duration.zero,
        );
        changed = true;
      }

      if (changed) {
        final index = _videos.indexWhere((v) => v.id == video.id);
        if (index != -1) {
          _videos[index] = updatedVideo;
          _filterVideos();
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to mark as not played: ${e.toString()}';
      notifyListeners();
    }
  }

  // Load playlists
  Future<void> loadPlaylists() async {
    _playlistsLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _playlists = await _playlistService.getAllPlaylists();
    } catch (e) {
      _errorMessage = 'Failed to load playlists: ${e.toString()}';
    } finally {
      _playlistsLoading = false;
      notifyListeners();
    }
  }

  // Create playlist
  Future<Playlist?> createPlaylist(String name) async {
    final exists = _playlists.any(
      (p) => p.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) {
      return null;
    }
    try {
      final newPlaylist = Playlist(
        name: name,
        isFavorite: false,
        videos: [],
        audios: [],
      );
      final id = await _playlistService.createPlaylist(playlist: newPlaylist);
      final createdPlaylist = newPlaylist.copyWith(id: id);
      _playlists.add(createdPlaylist);
      notifyListeners();
      return createdPlaylist;
    } catch (e) {
      _errorMessage = 'Failed to create playlist: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  // Add to Playlist
  Future<void> addToPlaylist(Video video, List<Playlist> playlistList) async {
    try {
      for (Playlist playlist in playlistList) {
        await _videoService.addToPlaylist(video: video, playlist: playlist);
      }
      await loadPlaylists();
    } catch (e) {
      _errorMessage = 'Failed to add to playlist: ${e.toString()}';
      notifyListeners();
    }
  }

  double getPlaybackProgress({required Video video}) {
    if (video.length.inMilliseconds == 0) return 0.0;
    return video.resumeTimeStamp.inMilliseconds / video.length.inMilliseconds;
  }
}
