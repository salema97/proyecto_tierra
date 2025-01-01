class Extensometro {
  final int id;
  final String name;
  final int zonaId;

  Extensometro({required this.id, required this.name, required this.zonaId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'zonaId': zonaId,
    };
  }

  factory Extensometro.fromJson(Map<String, dynamic> json) {
    return Extensometro(id: json['id'], name: json['name'], zonaId: json['zonaId']);
  }
}
