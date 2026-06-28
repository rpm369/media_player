class AppDirectory {
  final int? id;
  final String directoryPath;

  const AppDirectory({this.id, required this.directoryPath});

  AppDirectory copyWith({required int? id, String? directoryPath}) {
    return AppDirectory(
      id: id,
      directoryPath: directoryPath ?? this.directoryPath,
    );
  }
}
