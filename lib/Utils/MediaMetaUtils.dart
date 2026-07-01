import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/stream_information.dart';
import 'package:flutter/services.dart';
import 'package:media_player/DomainModels/AudioInfo.dart';
import 'package:media_player/DomainModels/VideoInfo.dart';
import 'package:media_player/Utils/PathUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaMetaUtils {
  static Future<int> getMediaSizeInBytes({required String mediaPath}) async {
    return await File(mediaPath).length();
  }

  static Future<String> changeMediaName({
    required String filePath,
    required String newName,
  }) async {
    if (newName.isEmpty) throw Exception("New name cannot be empty");

    String extension = PathUtils.getExtension(path: filePath);
    String path = PathUtils.getDirectoryPath(filePath: filePath);
    String newPath = PathUtils.join(path1: path, path2: newName + extension);
    await File(filePath).rename(newPath);
    return newPath;
  }

  static Future<Uint8List?> extractVideoThumbnail({
    required String path,
  }) async {
    Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 200,
      maxWidth: 200,
      quality: 100,
    );
    return thumbnail;
  }

  static Future<Uint8List?> extractAudioAlbumCover({
    required String path,
  }) async {
    // Write the cover to a temp file since FFmpegKit can't return bytes directly
    final tempDir = await getTemporaryDirectory();
    final outputPath =
        '${tempDir.path}/cover_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final session = await FFmpegKit.execute(
      '-i "$path" -an -vcodec copy -y "$outputPath"',
    );

    final returnCode = await session.getReturnCode();

    if (!ReturnCode.isSuccess(returnCode)) {
      // File has no embedded cover art, or the format doesn't support it
      return null;
    }

    final coverFile = File(outputPath);

    if (!await coverFile.exists()) return null;

    final bytes = await coverFile.readAsBytes();

    // Clean up the temp file
    await coverFile.delete();

    return bytes.isEmpty ? null : bytes;
  }

  static Future<Duration> getMediaLength({required String path}) async {
    final session = await FFprobeKit.getMediaInformation(path);
    final info = await session.getMediaInformation();

    // Duration is a top-level property, not per-stream
    final durationSeconds = double.tryParse(info?.getDuration() ?? '') ?? 0.0;
    final duration = Duration(milliseconds: (durationSeconds * 1000).toInt());
    return duration;
  }

  static Future<VideoInfo> extractVideoInfo({required String path}) async {
    final session = await FFprobeKit.getMediaInformation(path);
    final info = await session.getMediaInformation();
    final streams = info?.getStreams() ?? [];

    for (final StreamInformation stream in streams) {
      final props = stream.getAllProperties();
      // 1. Fixed: 'type' -> 'codec_type'
      final type = props?['codec_type'] as String?;

      if (type == 'video') {
        final width = props?['width'] ?? 0;
        final height = props?['height'] ?? 0;
        final fpsStr = props?['avg_frame_rate'] as String? ?? '0/1';
        final fpsParts = fpsStr.split('/');
        final fps = fpsParts.length == 2
            ? double.parse(fpsParts[0]) / double.parse(fpsParts[1])
            : 0.0;

        return VideoInfo(
          // 2. Fixed: 'codec' -> 'codec_name'
          codec: props?['codec_name'] as String? ?? '',
          language: (props?['tags'] as Map?)?['language'] as String? ?? 'und',
          resolution: '${width}x${height}',
          frameRate: fps,
        );
      }
    }

    throw Exception('No video stream found in: $path');
  }

  static Future<AudioInfo?> extractAudioInfo({required String path}) async {
    final session = await FFprobeKit.getMediaInformation(path);
    final info = await session.getMediaInformation();
    final streams = info?.getStreams() ?? [];

    for (final StreamInformation stream in streams) {
      final props = stream.getAllProperties();
      // 1. Fixed: 'codec_type'
      final type = props?['codec_type'] as String?;

      if (type == 'audio') {
        return AudioInfo(
          // 2. Fixed: 'codec_name'
          codec: props?['codec_name'] as String? ?? '',
          language: (props?['tags'] as Map?)?['language'] as String? ?? 'und',
          // 3. Fixed: 'bit_rate'
          bitRate: int.tryParse(props?['bit_rate']?.toString() ?? '') ?? 0,
          // 4. Fixed: 'channel_layout' (Note: 'channels' is correct as-is)
          channelCount: props?['channel_layout'] != null
              ? _parseChannels(props!['channel_layout'] as String)
              : (int.tryParse(props?['channels']?.toString() ?? '') ?? 0),
          // 5. Fixed: 'sample_rate'
          sampleRate:
              int.tryParse(props?['sample_rate']?.toString() ?? '') ?? 0,
        );
      }
    }

    return null;
  }

  static int _parseChannels(String layout) {
    if (layout == 'stereo') return 2;
    if (layout == 'mono') return 1;
    return int.tryParse(layout.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}
