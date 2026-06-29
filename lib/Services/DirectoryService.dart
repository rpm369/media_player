import 'dart:io';

import 'package:media_player/DomainModels/AppDirectory.dart';
import 'package:media_player/Repos/DirectoryRepo.dart';
import 'package:path/path.dart' as p;

class DirectoryService {
  final DirectoryRepository _repo;
  DirectoryService({required this._repo});

  Future<List<AppDirectory>> getAllFavoriteDirectory() async {
    List<AppDirectory> allFavDir = await _repo.getAllFavoriteDirectory();
    List<AppDirectory> validDirs = [];
    for (AppDirectory dir in allFavDir) {
      bool existInDisk = await Directory(dir.directoryPath).exists();
      if (!existInDisk) {
        await removeFromFavorite(dir: dir);
      } else {
        validDirs.add(dir);
      }
    }
    return validDirs;
  }

  Future<int> addToFavorite({required AppDirectory dir}) async {
    return await _repo.addToFavorite(dir: dir);
  }

  Future<void> removeFromFavorite({required AppDirectory dir}) async {
    await _repo.removeFromFavorite(id: dir.id!);
  }

  Future<void> deleteDirectory({required AppDirectory dir}) async {
    if (dir.id != null) await removeFromFavorite(dir: dir);
    await Directory(dir.directoryPath).delete(recursive: true);
  }

  Future<void> renameDirectory({
    required AppDirectory dir,
    required String newName,
  }) async {
    Directory directory = Directory(dir.directoryPath);
    String currentPath = p.dirname(directory.path);

    String newPath = p.join(currentPath, newName);
    await directory.rename(newPath);

    if (dir.id != null) {
      await removeFromFavorite(dir: dir);
      await addToFavorite(dir: AppDirectory(directoryPath: newPath));
    }
  }
}
