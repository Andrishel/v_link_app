class AlertaModel {
  final int idAlerta;
  final int idVehiculo;
  final String tipoAlerta;
  final String descripcion;
  final DateTime fechaHora;

  AlertaModel({
    required this.idAlerta,
    required this.idVehiculo,
    required this.tipoAlerta,
    required this.descripcion,
    required this.fechaHora,
  });

  factory AlertaModel.fromMap(Map<String, dynamic> map) {
    return AlertaModel(
      idAlerta: map['id_alerta'] ?? 0,
      idVehiculo: map['id_vehiculo'] ?? 0,
      tipoAlerta: map['tipo_alerta'] ?? 'Alerta General',
      descripcion: map['descripcion'] ?? '',
      fechaHora: map['fecha_hora'] != null 
          ? DateTime.parse(map['fecha_hora'].toString()) 
          : DateTime.now(),
    );
  }
}