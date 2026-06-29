import 'dart:io';

import 'package:mime/mime.dart';

class FileTypeUtil {
  static FileType checkFileType({required FileSystemEntity file}) {
    if (file is Directory) return FileType.DIRECTORY;

    String? mimeType = lookupMimeType(file.path);

    switch (mimeType?.split('/').first) {
      case 'image':
        return FileType.IMAGE;

      case 'video':
        return FileType.VIDEO;

      case 'audio':
        return FileType.AUDIO;

      default:
        return FileType.UNKNOWN;
    }
  }

  static bool isVideo({required FileSystemEntity file}) {
    String? mimeType = lookupMimeType(file.path);
    return mimeType == FileType.VIDEO.id;
  }

  static bool isAudio({required FileSystemEntity file}) {
    String? mimeType = lookupMimeType(file.path);
    return mimeType == FileType.AUDIO.id;
  }
}

enum FileType {
  UNKNOWN('unknown'),
  DIRECTORY('directory'),
  VIDEO('video'),
  AUDIO('audio'),
  IMAGE('image'),
  PDF('pdf');

  final String id;
  const FileType(this.id);
}
