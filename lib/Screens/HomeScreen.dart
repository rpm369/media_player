import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_player/ViewModels/VideosViewModel.dart';
import 'package:media_player/Views/VideosView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _titles = ['VLC', 'Audio', 'Browse', 'Playlists', 'More'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Stop search if switching tabs
    if (index != 0) {
      final viewModel = Provider.of<VideosViewModel>(context, listen: false);
      if (viewModel.isSearching) {
        _searchController.clear();
        viewModel.stopSearch();
      }
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const VideosView();
      case 1:
        return const Center(
          child: Text(
            'Audio Page',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      case 2:
        return const Center(
          child: Text(
            'Browse Page',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      case 3:
        return const Center(
          child: Text(
            'Playlists Page',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      case 4:
        return const Center(
          child: Text(
            'More Page',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      default:
        return const VideosView();
    }
  }

  PreferredSizeWidget _buildAppBar(VideosViewModel viewModel) {
    if (_currentIndex == 0) {
      return AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: viewModel.isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _searchController.clear();
                  viewModel.stopSearch();
                },
              )
            : Container(
                padding: const EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 10),
                child: Image.asset('assets/images/vlc.png'),
              ),
        title: viewModel.isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search videos...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (query) => viewModel.updateSearchQuery(query),
              )
            : Text(
                _titles[_currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        actions: [
          if (viewModel.isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                viewModel.updateSearchQuery('');
              },
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => viewModel.startSearch(),
            ),
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                // Play again / history (no implementation)
              },
            ),
          ],
        ],
      );
    }

    return AppBar(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      title: Text(
        _titles[_currentIndex],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideosViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(viewModel),
          body: _buildBody(),
          floatingActionButton:
              _currentIndex == 0 && viewModel.videos.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () => viewModel.playAll(),
                  backgroundColor: const Color(0xFFFF8800),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.play_arrow_rounded, size: 36),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF1E1E1E),
            selectedItemColor: const Color(0xFFFF8800),
            unselectedItemColor: Colors.grey[500],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                activeIcon: Icon(Icons.video_library),
                label: 'Video',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined),
                activeIcon: Icon(Icons.music_note),
                label: 'Audio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_outlined),
                activeIcon: Icon(Icons.folder),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_play_rounded),
                activeIcon: Icon(Icons.playlist_play),
                label: 'Playlists',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz_outlined),
                activeIcon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}
