part of 'bloc_posesion_bloc.dart';

abstract class PosesionEvent extends Equatable {
  const PosesionEvent();

  @override
  List<Object> get props => [];

}

class PosesionEventCargarLista extends PosesionEvent{

}
class PosesionEventCargarListaPropia extends PosesionEvent{
  String idUser;
  PosesionEventCargarListaPropia(this.idUser);
}
