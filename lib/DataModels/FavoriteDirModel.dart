class FavoriteDirectoryModel {
  final int? id;
  final String directoryPath;

  const FavoriteDirectoryModel({this.id, required this.directoryPath});

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'directoryPath': this.directoryPath};
  }

  factory FavoriteDirectoryModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return FavoriteDirectoryModel(
      id: json['id'],
      directoryPath: json['directoryPath'],
    );
  }

  FavoriteDirectoryModel copyWith({required int? id, String? directoryPath}) {
    return FavoriteDirectoryModel(
      id: id,
      directoryPath: directoryPath ?? this.directoryPath,
    );
  }
}
