
import 'package:equatable/equatable.dart';

import 'equipo.dart';

class GrupoEquipo extends Equatable{
  final String nombre, estado;
  final List<Equipo> equipos;

  GrupoEquipo(this.nombre,this.estado,this.equipos);
  GrupoEquipo.fromJson(Map<String, dynamic> json):
      nombre = json["nombre"],
      estado = json["estado"],
      equipos = List.from(json["equipos"]).map((e) => Equipo.fromJson(e)).toList();

  @override
  List<Object> get props => [nombre, estado, equipos];
}