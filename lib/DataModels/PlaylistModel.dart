class PlaylistModel {
  final int? id;
  final String name;

  const PlaylistModel({this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'name': this.name};
  }

  factory PlaylistModel.fromJson({required Map<String, dynamic> json}) {
    return PlaylistModel(id: json['id'], name: json['name']);
  }

  PlaylistModel copyWith({required int? id, String? name}) {
    return PlaylistModel(id: id, name: name ?? this.name);
  }
}
