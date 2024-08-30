import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('API Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: fetch,
            child: Text('Fetch Data'),
          ),
        ),
      ),
    );
  }

  void fetch() async {
    var url = Uri.parse('https://955e-2804-7efc-32c-4a01-3953-1aa8-e0ce-c0c5.ngrok-free.app/users/login');
    var body = {"email": "fabianojesus1991@gmail.com", "senha": "12345678"};
    var jsonBody = jsonEncode(body);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Se o servidor retornar um código 200 OK, parse o JSON.
        print('Resposta: ${response.body}');
      } else {
        // Se a resposta não for um código 200, levante uma exceção.
        print('Falha ao fazer login: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
