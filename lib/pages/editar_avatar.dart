import 'dart:convert';
import 'dart:math';

import 'package:avatar_maker/avatar_maker.dart';
import 'package:eurointegrate_app/avatar/maker.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarAvatar extends StatelessWidget {
  final String token;
  final int pontos;
  final int id;
  EditarAvatar({super.key, required this.token, required this.pontos, required this.id});

  Future<void> _save(String avatar) async {
  var url = Uri.parse('$urlAPI/colaboradores/avatar/$id');
  var body = {"avatar": avatar};
  var jsonBody = jsonEncode(body);
  http.Response? response;

  try {
    response = await http.patch(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save data');
    }
  } catch (e) {
    print("Erro na requisição: $e");
    return null;
  }
}



  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edição de avatar"),
        backgroundColor: azulEuro,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: AvatarMakerAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Seus pontos: ${pontos}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Icon(Icons.star, color: Colors.amber,)
                      ],
                    ),
                    Spacer(),
                    AvatarMakerSaveWidget(onTap: () async {_save(await AvatarMakerController.getJsonOptions());},),
                    AvatarMakerResetWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: MakerCustomizer(
                  //Minha pontuação
                  myPoints: pontos,
                  scaffoldWidth: min(600, _width * 0.85),
                  autosave: false,
                  theme: AvatarMakerThemeData(
                      boxDecoration: BoxDecoration(boxShadow: [BoxShadow()])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}