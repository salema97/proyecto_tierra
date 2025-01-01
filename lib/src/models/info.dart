class Info {
  final int id;
  final String name;
  final int zonaId;
  final List<InfoDetail> info;

  Info({
    required this.id,
    required this.name,
    required this.zonaId,
    required this.info,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zonaId': zonaId,
      'info': info.map((detail) => detail.toJson()).toList(),
    };
  }

  factory Info.fromJson(Map<String, dynamic> json) {
    var infoList = json['info'] as List;
    List<InfoDetail> infoDetails = infoList.map((i) => InfoDetail.fromJson(i)).toList();

    return Info(
      id: json['id'],
      name: json['name'],
      zonaId: json['zonaId'],
      info: infoDetails,
    );
  }
}

class InfoDetail {
  final int id;
  final String temperaturaMAX6675;
  final String temperaturaLM35;
  final String humedadRelativa;
  final bool esDia;
  final String corrienteCS712;
  final String nivelBateria;
  final String desplazamientoLineal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int extensometroId;

  InfoDetail({
    required this.id,
    required this.temperaturaMAX6675,
    required this.temperaturaLM35,
    required this.humedadRelativa,
    required this.esDia,
    required this.corrienteCS712,
    required this.nivelBateria,
    required this.desplazamientoLineal,
    required this.createdAt,
    required this.updatedAt,
    required this.extensometroId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperaturaMAX6675': temperaturaMAX6675,
      'temperaturaLM35': temperaturaLM35,
      'humedadRelativa': humedadRelativa,
      'esDia': esDia,
      'corrienteCS712': corrienteCS712,
      'nivelBateria': nivelBateria,
      'desplazamientoLineal': desplazamientoLineal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'extensometroId': extensometroId,
    };
  }

  factory InfoDetail.fromJson(Map<String, dynamic> json) {
    return InfoDetail(
      id: json['id'],
      temperaturaMAX6675: json['temperaturaMAX6675'],
      temperaturaLM35: json['temperaturaLM35'],
      humedadRelativa: json['humedadRelativa'],
      esDia: json['esDia'],
      corrienteCS712: json['corrienteCS712'],
      nivelBateria: json['nivelBateria'],
      desplazamientoLineal: json['desplazamientoLineal'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      extensometroId: json['extensometroId'],
    );
  }
}
