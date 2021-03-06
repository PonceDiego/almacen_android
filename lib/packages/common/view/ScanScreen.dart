import 'package:almacen_android/packages/common/bloc/bloc_navigator_bloc.dart';
import 'package:almacen_android/packages/common/bloc/scan_screen_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class ScanScreen extends StatelessWidget{
  final bool llaves;
  ScanScreen({Key key, @required this.llaves}) : super (key : key);


  @override
  Widget build(BuildContext context) {
   _scannear(context);
   return BlocListener<ScanScreenBloc, ScanScreenState>(
      listener: (context, state) {
      if(state.equipo!=null){
        BlocProvider.of<NavigatorBloc>(context).add(NavigatorEventPushPage(10,parametro: state.equipo));
      }else if(state.articulo!=null){
        BlocProvider.of<NavigatorBloc>(context).add(NavigatorEventPushPage(0,parametro: state.articulo.nombre));

      }else if(state.grupoLlave!=null){
        BlocProvider.of<NavigatorBloc>(context).add(NavigatorEventPushPage(22,parametro: state.grupoLlave));

      }else if(state.grupoEquipo!=null){
        BlocProvider.of<NavigatorBloc>(context).add(NavigatorEventPushPage(12,parametro: state.grupoEquipo));

      }
    },
    child: Container(
      child: Center(child: ElevatedButton.icon(onPressed:()=> _scannear(context), icon: const Icon(Icons.camera_alt), label: Text("Abrir cámara"))),
    ),);
  }

  Future<void> _scannear (BuildContext context) async{
    await Permission.camera.request();
    String resultado = await FlutterBarcodeScanner.scanBarcode("#ff0000", "Cancelar", true, ScanMode.QR);
    if(resultado != null) {
      print(resultado);
      if (RegExp("grupoL{1}-.{1,}-[0-9]{1,}").hasMatch(resultado)) {
        if(llaves){
          BlocProvider.of<ScanScreenBloc>(context).add(
              ScanEventGetGrupoLlave(resultado));
        }else{
          EasyLoading.showToast("El usuario actual no posee permisos para visualizar llaves!");
        }
      } else if (RegExp("grupoE{1}-.{1,}-[0-9]{1,}").hasMatch(resultado)) {
        BlocProvider.of<ScanScreenBloc>(context).add(
            ScanEventGetGrupoEquipo(resultado));
      } else if (RegExp("equipo{1}-.{1,}-[0-9]{1,}").hasMatch(resultado)) {
        BlocProvider.of<ScanScreenBloc>(context).add(
            ScanEventGetEquipo(resultado));
      } else if (RegExp("articulo{1}-.{1,}-[0-9]{1,}").hasMatch(resultado)) {
        BlocProvider.of<ScanScreenBloc>(context).add(
            ScanEventGetArticulo(resultado));
      } else {
        EasyLoading.showToast("Qr no compatible.");
      }
    }else{
      EasyLoading.showToast("Se canceló la operación");
    }
  }


}