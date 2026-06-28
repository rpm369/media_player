class AppDirectoryModel {
  final int? id;
  final String directoryPath;

  const AppDirectoryModel({this.id, required this.directoryPath});

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'directoryPath': this.directoryPath};
  }

  factory AppDirectoryModel.fromJson({required Map<String, dynamic> json}) {
    return AppDirectoryModel(
      id: json['id'],
      directoryPath: json['directoryPath'],
    );
  }

  AppDirectoryModel copyWith({required int? id, String? directoryPath}) {
    return AppDirectoryModel(
      id: id,
      directoryPath: directoryPath ?? this.directoryPath,
    );
  }
}
