class Zona {
  final int id;
  final String name;

  Zona({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
    };
  }

  factory Zona.fromJson(Map<String, dynamic> json) {
    return Zona(id: json['id'], name: json['name']);
  }
}
