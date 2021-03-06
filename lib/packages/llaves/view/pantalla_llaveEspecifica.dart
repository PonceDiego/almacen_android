import 'package:almacen_android/packages/common/common_api_calls.dart';
import 'package:almacen_android/packages/llaves/bloc/bloc_llave_bloc.dart';
import 'package:almacen_android/packages/llaves/model/modelLlaves.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LlaveEspecifica extends StatelessWidget{

  String id;
  LlaveEspecifica({Key key, @required this.id}):super(key: key);
  Llave llave;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LlaveBloc>(context).add(LlaveCargarLlave(id));
    return BlocListener<LlaveBloc, LlaveState>(listener: (context, state){
      if(state.carga){
        EasyLoading.show();
      }else{
        EasyLoading.dismiss();
      }
    },
      child: BlocBuilder<LlaveBloc,LlaveState>(
        builder: (context,state){
          if(state.llave == null){
            return Container(child: Text("No se encontró llave con el id ingresado, por favor inténtelo nuevamente."),);
          }else{
            llave = state.llave;
            return Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(child:
                          Text("Número de copia",style: TextStyle(color: Colors.grey),),
                          ),
                          Expanded(child:
                          Text("Nombre",style: TextStyle(color: Colors.grey),),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child:
                          Text(llave.copia),
                          ),
                          Expanded(
                            child:
                            Text(llave.nombre),
                          )
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(child: Text("Ubicación",style: TextStyle(color: Colors.grey),)),
                          Expanded(child: Text("Observaciones", style: TextStyle(color: Colors.grey),))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(llave.ubicacion)),
                          Expanded(child: Text(llave.observaciones),)
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      Center(
                        child: Text("Estado",style: TextStyle(color:Colors.grey, fontSize: 16),),
                      ),
                      Center(
                        child: Text(llave.estado,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(height: 20.0,),
                      _buildButtons(context,llave.estado=="En uso"),
                    ],
                  ),
                ),
              ),
            );

          }
        },
      ),);


  }


  Widget _buildButtons(BuildContext context, bool entrada) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child:entrada?
      ElevatedButton(
            style:
            ElevatedButton.styleFrom(primary:Colors.green),
            onPressed: ()=> registrarEntrada(context),
            child: Text("Entrada",style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),)
      ):
      ElevatedButton(
            style: ElevatedButton.styleFrom(primary:Colors.red),
            onPressed: ()=> registrarSalida(context),
            child: Text("Salida", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),)
      )
      ,
    );
  }

  registrarSalida(BuildContext context) {
    //agregar modal
    String username;
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          hintText: "Usuario al cual asignar la llave",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          )
                      ),
                      controller: _controller,
                    ),
                    suggestionsCallback: (pattern) async{
                      return CommonApiCalls().getUserLikeNombre(pattern);
                    },
                    noItemsFoundBuilder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("No se encontró", style: TextStyle(fontSize: 20, color: Colors.black26),),
                      );
                    },
                    hideOnError: false,
                    itemBuilder: (context, itemData) {
                      if(itemData == "NO HAY"){
                        return Container();
                      }else{
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(itemData),
                        );
                      }
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion+"<-");
                      _controller.text = suggestion;
                      username = suggestion;
                    },
                  ),
                ),
                TextButton(onPressed: () {
                  if(username != null){
                    BlocProvider.of<LlaveBloc>(context).add(LlaveCambiarEstado(id,"En uso",username));
                    Navigator.pop(context);
                  }else{
                    EasyLoading.showToast("Debe seleccionar un usuario");
                  }

                }, child: Text("OK")),
              ],
            ) ,
          );
        });
  }

  registrarEntrada(BuildContext context) {
    EasyLoading.showToast("Entrada de la llave.");

    BlocProvider.of<LlaveBloc>(context).add(LlaveCambiarEstado(id,"Disponible", null));
  }
}

