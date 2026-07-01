import 'package:media_player/DomainModels/Video.dart';

class MathUtils {
  static double getPlaybackProgress({required Video video}) {
    if (video.length.inMilliseconds == 0) return 0.0;
    return video.resumeTimeStamp.inMilliseconds / video.length.inMilliseconds;
  }
}
