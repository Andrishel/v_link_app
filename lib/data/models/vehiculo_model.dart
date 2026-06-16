class VehiculoModel {
  final String idVehiculo;
  final String idUsuario;
  final String marca;
  final String modelo;
  final String placa;
  final String cilindraje;
  final int anio;
  final String color;

  VehiculoModel({
    required this.idVehiculo,
    required this.idUsuario,
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.cilindraje,
    required this.anio,
    required this.color,
  });

  factory VehiculoModel.fromMap(Map<String, dynamic> map) {
    return VehiculoModel(
      idVehiculo: map['id_vehiculo'].toString(),
      idUsuario: map['id_usuario'].toString(),
      marca: map['marca'] ?? 'Sin Marca',
      modelo: map['modelo'] ?? 'Sin Modelo',
      placa: map['placa'] ?? '---',
      cilindraje: map['cilindraje'] ?? '',
      anio: map['anio'] ?? 0,
      color: map['color'] ?? '',
    );
  }
}