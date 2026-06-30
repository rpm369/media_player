import 'package:path/path.dart' as p;

class PathUtils {
  static String getDirectoryOrFileName({required String path}) {
    return p.basename(path);
  }

  static String getFileNameWithoutExtension({required String path}) {
    return p.basenameWithoutExtension(path);
  }

  static String getDirectoryPath({required String filePath}) {
    return p.dirname(filePath);
  }

  static String getExtension({required String path}) {
    return p.extension(path);
  }

  static String join({
    required String path1,
    required String path2,
    List<String> otherPaths = const [],
  }) {
    String finalPath = p.join(path1, path2);
    for (String nextPath in otherPaths) {
      finalPath = p.join(finalPath, nextPath);
    }
    return finalPath;
  }
}
