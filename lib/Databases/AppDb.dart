import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDb {
  AppDb._();

  static Future<Database> get getDatabase async {
    if (_db == null) {
      await _initializeDb();
    }
    return _db!;
  }

  static Database? _db;

  static Future<void> _initializeDb() async {
    String dbPath = await _getDatabasePath();
    _db = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE FavouriteDirectory (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            directoryPath TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Audio (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filePath TEXT NOT NULL,
            length INTEGER NOT NULL,
            resumeTimeStamp INTEGER NOT NULL,
            isFavorite INTEGER NOT NULL DEFAULT 0,
            lastPlayedAt INTEGER,
            thumbnail BLOB
          )
        ''');

        await db.execute('''
          CREATE TABLE Video (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filePath TEXT NOT NULL,
            thumbnail BLOB,
            isFavorite INTEGER NOT NULL DEFAULT 0,
            length INTEGER NOT NULL,
            hasFinished INTEGER NOT NULL DEFAULT 0,
            resumeTimeStamp INTEGER NOT NULL,
            lastPlayedAt INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE Playlist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            isFavorite INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE VideoInfo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            videoId INTEGER UNIQUE NOT NULL,
            codec TEXT NOT NULL,
            language TEXT NOT NULL,
            resolution TEXT NOT NULL,
            frameRate REAL NOT NULL,
            FOREIGN KEY (videoId) REFERENCES Video (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE AudioInfo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            videoId INTEGER,
            audioId INTEGER,
            bitRate INTEGER NOT NULL,
            codec TEXT NOT NULL,
            language TEXT NOT NULL,
            channelCount INTEGER NOT NULL,
            sampleRate INTEGER NOT NULL,
            FOREIGN KEY (videoId) REFERENCES Video (id) ON DELETE CASCADE,
            FOREIGN KEY (audioId) REFERENCES Audio (id) ON DELETE CASCADE,
            CONSTRAINT chk_video_or_audio CHECK (
              (videoId IS NULL AND audioId IS NOT NULL) OR 
              (videoId IS NOT NULL AND audioId IS NULL)
            )
          )
        ''');

        await db.execute('''
          CREATE TABLE PlaylistAudio (
            playlistId INTEGER NOT NULL,
            audioId INTEGER NOT NULL,
            PRIMARY KEY (playlistId, audioId),
            FOREIGN KEY (playlistId) REFERENCES Playlist (id) ON DELETE CASCADE,
            FOREIGN KEY (audioId) REFERENCES Audio (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE PlaylistVideo (
            playlistId INTEGER NOT NULL,
            videoId INTEGER NOT NULL,
            PRIMARY KEY (playlistId, videoId),
            FOREIGN KEY (playlistId) REFERENCES Playlist (id) ON DELETE CASCADE,
            FOREIGN KEY (videoId) REFERENCES Video (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  static Future<String> _getDatabasePath() async {
    String appDocDirPath = (await getApplicationDocumentsDirectory()).path;
    String dbPath = path.join(appDocDirPath, DbConst.DB_NAME.id);
    return dbPath;
  }
}

enum DbConst {
  DB_NAME('appDb.db');

  final String id;
  const DbConst(this.id);
}
