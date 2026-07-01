import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/ViewModels/VideosViewModel.dart';
import 'Components/VideoCard.dart';
import 'Components/VideoOptionsBottomSheet.dart';
import 'Components/VideoInfoBottomSheet.dart';
import 'Components/PlaylistSelectionBottomSheet.dart';
import 'Components/DeleteConfirmationBottomSheet.dart';

class VideosView extends StatefulWidget {
  const VideosView({super.key});

  @override
  State<VideosView> createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  @override
  void initState() {
    super.initState();
    // Load videos within the init method of the view
    Future.microtask(() {
      if (mounted) {
        Provider.of<VideosViewModel>(context, listen: false).loadVideos();
      }
    });
  }

  void _showOptions(BuildContext context, Video video, VideosViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoOptionsBottomSheet(
        video: video,
        onPlay: () => viewModel.playVideo(video),
        onPlayFromStart: () => viewModel.playFromStart(video),
        onPlayAll: () => viewModel.playAll(),
        onAddToPlayQueue: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "${video.fileName}" to play queue'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFFFF8800),
            ),
          );
        },
        onShowInfo: () => _showInfoBottomSheet(context, video),
        onAddToPlaylist: () => _showPlaylistSelectionBottomSheet(context, video),
        onToggleFavorite: () => viewModel.toggleFavoriteStatus(video),
        onDelete: () =>
            _showDeleteConfirmationBottomSheet(context, video, viewModel),
        onTogglePlayedStatus: () => video.hasFinished
            ? viewModel.markAsNotPlayed(video)
            : viewModel.markAsPlayed(video),
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context, Video video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoInfoBottomSheet(video: video),
    );
  }

  void _showPlaylistSelectionBottomSheet(BuildContext context, Video video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlaylistSelectionBottomSheet(video: video),
    );
  }

  void _showDeleteConfirmationBottomSheet(
    BuildContext context,
    Video video,
    VideosViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeleteConfirmationBottomSheet(
        video: video,
        onDelete: () => viewModel.deleteVideo(video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideosViewModel>(
      builder: (context, viewModel, child) {
        return RefreshIndicator(
          onRefresh: () => viewModel.loadVideos(),
          color: const Color(0xFFFF8800),
          backgroundColor: const Color(0xFF1E1E1E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Capitalised/Header "VIDEOS" matching reference styling
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VIDEOS',
                      style: TextStyle(
                        color: Color(0xFFFF8800),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 55,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8800),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ],
                ),
              ),
              // Videos Grid or Loading/Error State
              Expanded(
                child: _buildBody(context, viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, VideosViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8800)),
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.loadVideos(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8800),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.videos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                viewModel.isSearching
                    ? Icons.search_off_rounded
                    : Icons.video_library_outlined,
                color: Colors.white30,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.isSearching
                    ? 'No videos match your search'
                    : 'No videos found on your device',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.18,
      ),
      itemCount: viewModel.videos.length,
      itemBuilder: (context, index) {
        final video = viewModel.videos[index];
        final progress = viewModel.getPlaybackProgress(video: video);
        return VideoCard(
          video: video,
          playbackProgress: progress,
          onTap: () => viewModel.playVideo(video),
          onOptionsTap: () => _showOptions(context, video, viewModel),
        );
      },
    );
  }
}
