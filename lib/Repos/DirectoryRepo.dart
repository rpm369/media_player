import 'package:media_player/DomainModels/AppDirectory.dart';

abstract class DirectoryRepository {
  Future<int> addToFavorite({required AppDirectory dir});
  Future<List<AppDirectory>> getAllFavoriteDirectory();
  Future<void> removeFromFavorite({required int id});
}
