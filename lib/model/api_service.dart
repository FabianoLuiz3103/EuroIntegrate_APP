import 'dart:convert';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String token;
  final int id;
  ApiService({required this.token, required this.id});

  Future<void> enviarDados(double pgr, int pts, int qtdRespondidas, int qtdCertas) async {
     var url = Uri.parse(
        '$urlAPI/colaboradores/atualizar/$id');
    var body = {"porcProgresso": pgr, "pontuacao": pts, "qtdRespondidas": qtdRespondidas, "qtdCertas": qtdCertas};
    var jsonBody = jsonEncode(body);
    http.Response? response;
    try {
      response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"},
        body: jsonBody,
      );
        
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> enviarRespostas(List<dynamic> respostas) async {
    print("enviando respostas");
    var url = Uri.parse(
        '$urlAPI/colaboradores/resposta');
    List jsonRespostas = respostas.map((r) => r.toJson()).toList();


Map<String, dynamic> body = {
  'dadosRespostas': jsonRespostas,
};
//print(body);

String jsonBody = jsonEncode(body);
//print(jsonBody);
  
    http.Response? response;
    try {
      response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
        "Content-Type": "application/json"},
        body: jsonBody,
      );
      print("STS CODE: ${response.statusCode}");
       
    } catch (e) {
      print('Erro: $e');
    }
}
}