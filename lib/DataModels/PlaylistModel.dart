class PlaylistModel {
  final int? id;
  final bool isFavorite;
  final String name;

  const PlaylistModel({this.id, required this.name, required this.isFavorite});

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'isFavorite': (this.isFavorite) ? 1 : 0,
    };
  }

  factory PlaylistModel.fromJson({required Map<String, dynamic> json}) {
    return PlaylistModel(
      id: json['id'],
      name: json['name'],
      isFavorite: (json['isFavorite'] == 1),
    );
  }

  PlaylistModel copyWith({required int? id, String? name, bool? isFavorite}) {
    return PlaylistModel(
      id: id,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
