import 'package:almacen_android/packages/almacen/data/api_calls.dart';
import 'package:almacen_android/packages/almacen/model/articulo.dart';
import 'package:almacen_android/packages/almacen/model/modelAlmacen.dart';
import 'package:almacen_android/packages/almacen/model/pojo/articulo_nvopedido.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bloc_almacen_nuevoPedido_event.dart';
part 'bloc_almacen_nuevoPedido_state.dart';


class NuevoPedidoBloc extends Bloc<NuevoPedidoEvent,NuevoPedidoState>{
  NuevoPedidoBloc() : super (NuevoPedidoState());
  Servidor _servidor = Servidor();

  @override
  Stream<NuevoPedidoState> mapEventToState(NuevoPedidoEvent event,) async*{
    if (event is NuevoPedidoEventClear){
      if(state.articulosAPedir == null){
        state.articulosAPedir = [];
      }else {
        state.articulosAPedir.clear();
      }
      yield state.copyWith(observaciones: "");
    }else if (event is NuevoPedidoEventAddArt){
      NuevoPedidoEventAddArt eventAddArt = event;

      Artxcant artxcant = new Artxcant(eventAddArt.nombreArt, eventAddArt.cantidad);
      List<Artxcant> nuevaLista = state.articulosAPedir;
      nuevaLista.add(artxcant);

      yield state.copyWith(articulosAPedir: nuevaLista);
    }
    if(event is NuevoPedidoEventDeleteArt){
      NuevoPedidoEventDeleteArt eventDeleteArt= event;
      List<Artxcant> artsApedir= state.articulosAPedir;
      for(int i = 0; i<artsApedir.length;i++){
        if(artsApedir[i].nombreArt == eventDeleteArt.nombreArt){

          artsApedir.removeAt(i);
        }
      }
      yield state.copyWith(articulosAPedir: artsApedir);
    }
    if (event is NuevoPedidoEventSavePedido){
//TODO: Terminar cuando el back sepa que va a recibir un array xD
      await _servidor.crearPedido(state.observaciones, state.nombreUsuario, state.articulosAPedir);
    }
    if (event is NuevoPedidoEventSetUser){
      NuevoPedidoEventSetUser eventSetUser = event;

      yield state.copyWith(nombreUsuario: eventSetUser.username);
    }
    if(event is NuevoPedidoInitialize){

      List<String> lstusuarios = await _servidor.listarUsuarios();
      List<Articulo> articulos =  await _servidor.listarArticulos();
      //TODO: que pasa si la lista esta vacia o null?
      yield state.copyWith(listaUsuarios: lstusuarios, nombreUsuario: lstusuarios[0], listaArticulos: articulos);
    }
  }
}