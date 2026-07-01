import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_player/DomainModels/Video.dart';
import 'package:media_player/ViewModels/VideosViewModel.dart';
import 'PlaylistCover.dart';

class PlaylistSelectionBottomSheet extends StatefulWidget {
  final Video video;

  const PlaylistSelectionBottomSheet({
    super.key,
    required this.video,
  });

  @override
  State<PlaylistSelectionBottomSheet> createState() =>
      _PlaylistSelectionBottomSheetState();
}

class _PlaylistSelectionBottomSheetState
    extends State<PlaylistSelectionBottomSheet> {
  final TextEditingController _playlistNameController = TextEditingController();
  final Set<int> _selectedPlaylistIds = {};

  @override
  void initState() {
    super.initState();
    // Load playlists from the ViewModel when the sheet is initialized
    Future.microtask(() {
      if (mounted) {
        Provider.of<VideosViewModel>(context, listen: false).loadPlaylists();
      }
    });
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.redAccent}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _createNewPlaylist(VideosViewModel viewModel) async {
    final name = _playlistNameController.text.trim();
    if (name.isEmpty) return;

    try {
      final createdPlaylist = await viewModel.createPlaylist(name);

      if (createdPlaylist == null) {
        _showSnackBar('Playlist already exists', backgroundColor: Colors.orange);
        return;
      }

      _playlistNameController.clear();
      setState(() {
        _selectedPlaylistIds.add(createdPlaylist.id!);
      });

      _showSnackBar('Playlist "$name" created', backgroundColor: const Color(0xFFFF8800));
    } catch (e) {
      _showSnackBar('Failed to create playlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideosViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Add "${widget.video.fileName}" to Playlist',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // Create Playlist Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _playlistNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'New Playlist Name',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        fillColor: Colors.black.withAlpha(51),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _createNewPlaylist(viewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8800),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Create'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Playlists List
              if (viewModel.playlistsLoading)
                const SizedBox(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8800)),
                    ),
                  ),
                )
              else if (viewModel.playlists.isEmpty)
                const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      'No playlists available. Create one above!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = viewModel.playlists[index];
                      final isSelected =
                          _selectedPlaylistIds.contains(playlist.id);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedPlaylistIds.remove(playlist.id);
                            } else {
                              _selectedPlaylistIds.add(playlist.id!);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              PlaylistCover(playlist: playlist, size: 50),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      playlist.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${playlist.videos.length} videos',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                activeColor: const Color(0xFFFF8800),
                                checkColor: Colors.black,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedPlaylistIds.add(playlist.id!);
                                    } else {
                                      _selectedPlaylistIds.remove(playlist.id);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              // Done/Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _selectedPlaylistIds.isEmpty
                        ? null
                        : () async {
                            final selectedPlaylists = viewModel.playlists
                                .where((p) => _selectedPlaylistIds.contains(p.id))
                                .toList();

                            await viewModel.addToPlaylist(
                              widget.video,
                              selectedPlaylists,
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                              _showSnackBar(
                                'Added to ${selectedPlaylists.length} playlist(s)',
                                backgroundColor: Colors.green,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8800),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Add to Playlists'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
