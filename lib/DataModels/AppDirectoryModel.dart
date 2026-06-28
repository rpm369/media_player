import 'package:media_player/DomainModels/AppDirectory.dart';

class AppDirectoryModel {
  final int? id;
  final String directoryPath;

  const AppDirectoryModel({this.id, required this.directoryPath});

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'directoryPath': this.directoryPath};
  }

  AppDirectory toAppDirectory() {
    return AppDirectory(id: this.id, directoryPath: directoryPath);
  }

  factory AppDirectoryModel.fromAppDirectory({
    required AppDirectory appDirectory,
  }) {
    return AppDirectoryModel(
      id: appDirectory.id,
      directoryPath: appDirectory.directoryPath,
    );
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
