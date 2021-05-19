import 'dart:convert';

import 'package:almacen_android/packages/common/mindia_http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:almacen_android/packages/llaves/model/modelLlaves.dart';


class ServidorLlaves {

  final String ipServer =
  "http://vps-1791261-x.dattaweb.com:4455/almacen_api-0.0.1-SNAPSHOT" ;
      // "http://almacen.eldoce.com.ar";
  var client = http.Client();

  /**
   * Llamadas referentes a llaves
   */
  Future <Llave> getLlaveEspecifica (String id) async{

    String endpoint, params;
    endpoint="/llave";
    params="?id="+id;
    String url = ipServer + endpoint + params;
    print(Uri.parse(url));
    var response=await MindiaHttpClient.instance().get(Uri.parse(url));
    print("getLlaveEspecifica/ Status: "+response.statusCode.toString()+" Body: "+response.body);
    if(response.statusCode==200){

      var n = json.decode(response.body);
      Llave llave = Llave.fromJson(n);
      return llave;
    }
  }

  Future <void> changeLlaveEstado(String id, String entrada) async{
    String endpoint, params;
    endpoint = "/llave/change";
    params="?id="+id+"&entrada="+entrada;
    var response = await MindiaHttpClient.instance().get(Uri.parse(ipServer+endpoint+params));
    print("changeLlaveEstado/ Status: "+response.statusCode.toString()+", Body: "+response.body);

  }

  /**
   * Llamadas referentes a Grupos de llaves.
   */

  Future <GrupoLlave> getGrupoLlave(String identificacionGrupoLlaves) async{
    String endpoint, params;
    endpoint = "/grupoLlave";
    params = "?identificacion="+identificacionGrupoLlaves;
    var url = Uri.parse(ipServer + endpoint + params);
    var response = await MindiaHttpClient.instance().get(url);

    if(response.statusCode == 200){
      var n = json.decode(response.body);
      GrupoLlave grupoLlave = GrupoLlave.fromJson(n);
      return grupoLlave;
    }
  }
}