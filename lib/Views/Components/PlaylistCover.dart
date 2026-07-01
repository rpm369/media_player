import 'package:flutter/material.dart';
import 'package:media_player/DomainModels/Playlist.dart';

class PlaylistCover extends StatelessWidget {
  final Playlist playlist;
  final double size;

  const PlaylistCover({
    super.key,
    required this.playlist,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final videosWithThumbnails = playlist.videos
        .where((v) => v.thumbnail != null)
        .take(4)
        .toList();

    if (videosWithThumbnails.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage('assets/images/defaultThumbnail.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[900],
      ),
      child: _buildCollage(videosWithThumbnails),
    );
  }

  Widget _buildCollage(List<dynamic> videos) {
    if (videos.length == 1) {
      return Image.memory(
        videos[0].thumbnail!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else if (videos.length == 2) {
      return Row(
        children: [
          Expanded(
            child: Image.memory(
              videos[0].thumbnail!,
              fit: BoxFit.cover,
              height: size,
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Image.memory(
              videos[1].thumbnail!,
              fit: BoxFit.cover,
              height: size,
            ),
          ),
        ],
      );
    } else if (videos.length == 3) {
      return Row(
        children: [
          Expanded(
            child: Image.memory(
              videos[0].thumbnail!,
              fit: BoxFit.cover,
              height: size,
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Image.memory(
                    videos[1].thumbnail!,
                    fit: BoxFit.cover,
                    width: size / 2,
                  ),
                ),
                const SizedBox(height: 1),
                Expanded(
                  child: Image.memory(
                    videos[2].thumbnail!,
                    fit: BoxFit.cover,
                    width: size / 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // 4 videos (2x2 grid)
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.memory(
                    videos[0].thumbnail!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 1),
                Expanded(
                  child: Image.memory(
                    videos[1].thumbnail!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.memory(
                    videos[2].thumbnail!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 1),
                Expanded(
                  child: Image.memory(
                    videos[3].thumbnail!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
