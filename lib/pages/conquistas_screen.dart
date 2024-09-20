import 'dart:convert';
import 'dart:ui';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:flutter/material.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/model/conquista.dart';
import 'package:http/http.dart' as http;

class ConquistasScreen extends StatefulWidget {
    final String token;
    final int id;
  const ConquistasScreen({super.key, required this.token, required this.id});

  @override
  State<ConquistasScreen> createState() => _ConquistasScreenState();
}

class _ConquistasScreenState extends State<ConquistasScreen> {
  late Future<Pontuacao?> myPoints;

  Future<Pontuacao?> _fetchData() async {
    var url = Uri.parse(
        '$urlAPI/colaboradores/conquistas/${widget.id}');

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );
      if (response.statusCode == 200) {
        return parsePontuacao(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myPoints = _fetchData();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Conquistas"),
      backgroundColor: azulEuro,
    ),
    body: FutureBuilder<Pontuacao?>(
      future: myPoints,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: progressSkin(20));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar pontuação"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Nenhuma pontuação disponível"));
        } else {
          final pontuacao = snapshot.data!.pontuacao; // Obtém a pontuação
          return FutureBuilder<List<Conquista>>(
            future: loadConquistas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(child: progressSkin(20));
              } else if (snapshot.hasError) {
                return const Center(child: Text("Erro ao carregar conquistas"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Nenhuma conquista disponível"));
              } else {
                final conquistas = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 8),
                  child: ListView.separated(
                    itemCount: conquistas.length,
                    itemBuilder: (context, index) {
                      final isUnlocked = pontuacao >= conquistas[index].pontos; // Comparação aqui
                      return Stack(
                    children: [
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(conquistas[index].image),
                        ),
                        title: Text(conquistas[index].titulo),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding:
                                      EdgeInsets.zero, 
                                  content: SizedBox(
                                    width: 200, 
                                    child: Column(
                                      mainAxisSize: MainAxisSize
                                          .min, 
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  conquistas[index].image),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          conquistas[index].titulo,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(conquistas[index].descricao, style: TextStyle(), textAlign: TextAlign.center,),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: isUnlocked
                              ? const Icon(Icons.arrow_forward_ios)
                              : const Icon(Icons.block, color: Colors.white),
                        ),
                      ),
                      if (!isUnlocked)
                        Positioned.fill(
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.black.withOpacity(0.03),
                              ),
                            ),
                          ),
                        ),
                      if (!isUnlocked)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.star, color: Colors.amber),
                                  ),
                                  Text(
                                    conquistas[index].pontos.toString(),
                                    style: const TextStyle(color: azulEuro),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    ],
                  );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(); 
                    },
                  ),
                );
              }
            },
          );
        }
      },
    ),
  );
}

}

class Pontuacao{
  int pontuacao;

  Pontuacao({required this.pontuacao});

   factory Pontuacao.fromJson(Map<String, dynamic> json) {

    return Pontuacao(pontuacao: json['pontuacao']);
   }
}

Pontuacao parsePontuacao(String responseBody) {
  final Map<String, dynamic> json = jsonDecode(responseBody);
  return Pontuacao.fromJson(json);
}
