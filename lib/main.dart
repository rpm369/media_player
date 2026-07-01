import 'package:flutter/material.dart';
import 'package:media_player/Databases/SystemDb.dart';
import 'package:media_player/LocalRepositories/SystemLocalRepo.dart';
import 'package:media_player/Services/SystemService.dart';
import 'package:provider/provider.dart';
import 'package:media_player/Databases/AppDb.dart';
import 'package:media_player/LocalRepositories/VideoLocalRepo.dart';
import 'package:media_player/LocalRepositories/PlaylistLocalRepo.dart';
import 'package:media_player/LocalRepositories/AudioLocalRepo.dart';
import 'package:media_player/Services/VideoService.dart';
import 'package:media_player/Services/PlaylistService.dart';
import 'package:media_player/Services/AudioService.dart';
import 'package:media_player/ViewModels/VideosViewModel.dart';
import 'package:media_player/Screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get database instance
  final appDb = await AppDb.getDatabase;
  final systemDb = await SystemDb.getDatabase;

  // Repositories
  final systemRepo = SystemLocalRepo(db: systemDb);
  final videoRepo = VideoLocalRepo(db: appDb);
  final playlistRepo = PlaylistLocalRepo(db: appDb);
  final audioRepo = AudioLocalRepo(db: appDb);

  // Services
  // ignore: unused_local_variable
  final systemService = SystemService(repo: systemRepo);
  final videoService = VideoService(repo: videoRepo);
  final audioService = AudioService(repo: audioRepo);
  final playlistService = PlaylistService(
    repo: playlistRepo,
    audioService: audioService,
    videoService: videoService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VideosViewModel(
            videoService: videoService,
            playlistService: playlistService,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VLC Media Player',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFF8800),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8800),
          secondary: Color(0xFFFF8800),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
