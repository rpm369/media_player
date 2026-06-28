import 'package:media_player/DomainModels/AppDirectory.dart';
import 'package:media_player/Repos/DirectoryRepo.dart';

class DirectoryService {
  final DirectoryRepository _repo;
  DirectoryService({required this._repo});

  Future<void> addToFavorite({required AppDirectory dir}) async {}
  Future<void> removeFromFavorite({required AppDirectory dir}) async {}
  Future<void> deleteDirectory({required AppDirectory dir}) async {}
  Future<void> renameDirectory({
    required AppDirectory dir,
    required String newName,
  }) async {}
}
