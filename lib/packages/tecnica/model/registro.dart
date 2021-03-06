import 'package:equatable/equatable.dart';
import 'modelTecnica.dart';

class Registro extends Equatable{
  final Equipo equipo;
  final String usuario;
  final String fecha;
  final bool entrada;

  Registro(this.usuario,this.fecha,this.entrada,this.equipo);
  Registro.fromJson(Map<String, dynamic>json):
  equipo=json['equipo'],
  usuario=json['usuario.nombreUsuario'],
  fecha=json['fecha'],
  entrada=json['entrada'];

  @override
  List<Object> get props => [equipo,usuario,fecha,entrada ];
}