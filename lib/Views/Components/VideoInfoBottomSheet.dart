import 'package:flutter/material.dart';
import 'package:media_player/DomainModels/Video.dart';

class VideoInfoBottomSheet extends StatelessWidget {
  final Video video;

  const VideoInfoBottomSheet({
    super.key,
    required this.video,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    double kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    double mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    double gb = mb / 1024;
    return '${gb.toStringAsFixed(1)} GB';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${duration.inMinutes}:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('General'),
            _buildInfoRow('File Name', video.fileName),
            _buildInfoRow('Path', video.filePath),
            _buildInfoRow('Size', _formatSize(video.sizeInBytes)),
            _buildInfoRow('Duration', _formatDuration(video.length)),
            const SizedBox(height: 16),
            _buildSectionHeader('Video Stream'),
            _buildInfoRow('Codec', video.videoInfo.codec.toUpperCase()),
            _buildInfoRow('Resolution', video.videoInfo.resolution),
            _buildInfoRow(
              'Frame Rate',
              '${video.videoInfo.frameRate.toStringAsFixed(2)} fps',
            ),
            _buildInfoRow('Language', video.videoInfo.language),
            const SizedBox(height: 16),
            _buildSectionHeader('Audio Stream'),
            _buildInfoRow('Codec', video.audioInfo.codec.toUpperCase()),
            _buildInfoRow(
              'Bitrate',
              '${(video.audioInfo.bitRate / 1000).toStringAsFixed(0)} kbps',
            ),
            _buildInfoRow(
              'Sample Rate',
              '${(video.audioInfo.sampleRate / 1000).toStringAsFixed(1)} kHz',
            ),
            _buildInfoRow('Channels', '${video.audioInfo.channelCount} ch'),
            _buildInfoRow('Language', video.audioInfo.language),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8800),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF8800),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
