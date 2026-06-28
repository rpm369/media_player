import 'package:media_player/DataModels/AppDirectoryModel.dart';
import 'package:media_player/DomainModels/AppDirectory.dart';
import 'package:media_player/Repos/DirectoryRepo.dart';
import 'package:sqflite/sqflite.dart';

class DirectoryLocalRepo implements DirectoryRepository {
  final Database _db;
  const DirectoryLocalRepo({required this._db});

  @override
  Future<int> addToFavorite({required AppDirectory dir}) async {
    final model = AppDirectoryModel.fromAppDirectory(appDirectory: dir);
    return await _db.insert('FavouriteDirectory', model.toJson());
  }

  @override
  Future<List<AppDirectory>> getAllFavoriteDirectory() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'FavouriteDirectory',
    );
    return maps
        .map((map) => AppDirectoryModel.fromJson(json: map).toAppDirectory())
        .toList();
  }

  @override
  Future<void> removeFromFavorite({required int id}) async {
    await _db.delete('FavouriteDirectory', where: 'id = ?', whereArgs: [id]);
  }
}
