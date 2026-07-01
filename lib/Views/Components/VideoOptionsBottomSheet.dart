import 'package:flutter/material.dart';
import 'package:media_player/DomainModels/Video.dart';

class VideoOptionsBottomSheet extends StatelessWidget {
  final Video video;
  final VoidCallback onPlay;
  final VoidCallback onPlayFromStart;
  final VoidCallback onPlayAll;
  final VoidCallback onAddToPlayQueue;
  final VoidCallback onShowInfo;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;
  final VoidCallback onTogglePlayedStatus;

  const VideoOptionsBottomSheet({
    super.key,
    required this.video,
    required this.onPlay,
    required this.onPlayFromStart,
    required this.onPlayAll,
    required this.onAddToPlayQueue,
    required this.onShowInfo,
    required this.onAddToPlaylist,
    required this.onToggleFavorite,
    required this.onDelete,
    required this.onTogglePlayedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Video title header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                if (video.thumbnail != null)
                  Container(
                    width: 50,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: MemoryImage(video.thumbnail!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 50,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    video.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          // Scrollable Options List
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildOptionTile(
                    context,
                    icon: Icons.play_arrow_rounded,
                    label: 'Play',
                    onTap: onPlay,
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.replay_rounded,
                    label: 'Play from start',
                    onTap: onPlayFromStart,
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.playlist_play_rounded,
                    label: 'Play all',
                    onTap: onPlayAll,
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.queue_play_next_rounded,
                    label: 'Add to play queue',
                    onTap: onAddToPlayQueue,
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.info_outline_rounded,
                    label: 'Information',
                    onTap: onShowInfo,
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.playlist_add_rounded,
                    label: 'Add to playlist',
                    onTap: onAddToPlaylist,
                  ),
                  _buildOptionTile(
                    context,
                    icon: video.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: video.isFavorite ? const Color(0xFFFF8800) : null,
                    label: video.isFavorite
                        ? 'Remove from favourites'
                        : 'Add to Favorites',
                    onTap: onToggleFavorite,
                  ),
                  _buildOptionTile(
                    context,
                    icon: video.hasFinished
                        ? Icons.unpublished_outlined
                        : Icons.check_circle_outline_rounded,
                    label: video.hasFinished
                        ? 'Mark as not played'
                        : 'Mark as played',
                    onTap: onTogglePlayedStatus,
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.delete_outline_rounded,
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    label: 'Delete',
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.grey[400],
        size: 24,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      dense: true,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
