import 'package:media_player/DomainModels/FavoriteDirectory.dart';

abstract class DirectoryRepository {
  Future<int> addToFavorite({required FavoriteDirectory dir});
  Future<List<FavoriteDirectory>> getAllFavoriteDirectory();
  Future<void> removeFromFavorite({required int id});
}
