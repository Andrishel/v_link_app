class VehiculoModel {
  final int idVehiculo;
  final int idUsuario;
  final String marca;
  final String modelo;
  final String placa;
  final double cilindraje;
  final int anio;
  final String color;
  final bool isIgnited;

  VehiculoModel({
    required this.idVehiculo,
    required this.idUsuario,
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.cilindraje,
    required this.anio,
    required this.color,
    required this.isIgnited,
  });

  factory VehiculoModel.fromMap(Map<String, dynamic> map) {
    return VehiculoModel(
      idVehiculo: map['id_vehiculo'] ?? 0,
      idUsuario: map['id_usuario'] ?? 0,
      marca: map['marca'] ?? '',
      modelo: map['modelo'] ?? '',
      placa: map['placa'] ?? '',
      cilindraje: double.parse((map['cilindraje'] ?? 0.0).toString()),
      anio: map['anio'] ?? 0,
      color: map['color'] ?? '',
      isIgnited: map['is_ignited'] ?? false,
    );
  }
}