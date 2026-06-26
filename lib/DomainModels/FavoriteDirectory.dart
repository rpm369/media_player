class FavoriteDirectory {
  final int? id;
  final String directoryPath;

  const FavoriteDirectory({
    this.id,
    required this.directoryPath,
  });

  FavoriteDirectory copyWith({
    required int? id,
    String? directoryPath,
  }) {
    return FavoriteDirectory(
      id: id,
      directoryPath: directoryPath ?? this.directoryPath,
    );
  }
}
