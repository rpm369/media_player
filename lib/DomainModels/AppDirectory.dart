import 'package:media_player/Utils/PathUtils.dart';

class AppDirectory {
  final int? id;
  final String directoryPath;

  const AppDirectory({this.id, required this.directoryPath});

  String get title {
    return PathUtils.getDirectoryOrFileName(path: directoryPath);
  }

  AppDirectory copyWith({required int? id, String? directoryPath}) {
    return AppDirectory(
      id: id,
      directoryPath: directoryPath ?? this.directoryPath,
    );
  }
}
