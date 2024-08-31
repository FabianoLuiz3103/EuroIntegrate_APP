import 'dart:convert';

import 'package:eurointegrate_app/components/button_navigation.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/model/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuiaScreen extends StatefulWidget {
   final String token;
  final int id;
  const GuiaScreen({super.key, required this.token, required this.id});

  @override
  State<GuiaScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<GuiaScreen> {
  double _globalProgress = 0.0;

  List<DropdownMenuItem<String>> items = [
   const DropdownMenuItem(
      value: "gerais",
      child: Text("GERAIS"),
    ),
    const DropdownMenuItem(value: "departamento", child: Text("DEPARTAMENTO"))
  ];
  List<String> normasGerais = ["Geral 1", "Geral 2", "Geral 3", "Geral 4"];
  List<String> normasDpt = ["DPT 1", "DPT 2", "DPT 3", "DPT 4"];
  List<String> normasAtuais = [];
  String atual = "";



Future<List<List<Pergunta>>>? _fetchPerguntas;
  double pgr = 0.0;
  double pgrEnv = 0.0;
  int pts = 0;
  List<dynamic> respostas = [];
  int qtdRespondidas = 0;
  int qtdCertas = 0;
  List<Resposta> respondidas = [];
  int idUser = 0;
  late final ApiService apiService;


  Future<List<List<Pergunta>>> _fetchData() async {
    var url = Uri.parse('$urlAPI/colaboradores/normas-departamento/${widget.id}');
    String token = widget.token;

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
         List<int> bytes = response.bodyBytes;
    String decodedBody = utf8.decode(bytes);
    List<dynamic> data = jsonDecode(decodedBody);
        print(data);
        List<List<Pergunta>> perguntas = _inicializarPerguntas(data);
        return perguntas;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return [];
    }
  }

  Future<List<dynamic>> _fetchDataSeq() async {
    var url = Uri.parse('$urlAPI/colaboradores/videos-seq/${widget.id}');
    String token = widget.token;

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        
        idUser = data['idColaborador'];
        pgr = data['porcProgresso']/100;
        pts = data['pontuacao'];
        qtdRespondidas = data['qtdRespondidas'];
        qtdCertas = data['qtdCertas'];
        respostas = data['respostas'];
       // print(respostas);
       return respostas;
       
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return [];
    }
  }

  List<List<Pergunta>> _inicializarPerguntas(List<dynamic>? data) {
    if (data != null && data.isNotEmpty) {
      List<List<Pergunta>> perguntasList = [];
      for (var item in data) {
        if (item is Map<String, dynamic> && item.containsKey("perguntas")) {
          var perguntasData = item["perguntas"];
          if (perguntasData is List) {
            var perguntasSublista = perguntasData
                .map((perguntaJson) => Pergunta.fromJson(perguntaJson))
                .toList();
            perguntasList.add(perguntasSublista);
          } else {
            print('O valor de "perguntas" não é uma lista.');
          }
        } else {
          print('Item não contém a chave "perguntas" ou não é um mapa.');
        }
      }
      return perguntasList;
    } else {
      print('Dados não disponíveis ou estão vazios.');
      return [];
    }
  }


  @override
  void initState() {
    super.initState();
    normasAtuais = normasGerais;
    atual = "GERAIS";
    _fetchData();
  }

   @override
  void dispose() {
    Future.microtask(() async {
      await apiService.enviarDados(pgrEnv, pts, qtdRespondidas, qtdCertas);
      await apiService.enviarRespostas(respondidas);
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(atual),
        backgroundColor: azulEuro,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12.0, 0),
            child: DropdownButton(
              hint: const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Tipo de norma",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              items: items,
              onChanged: (String? value) {
                setState(() {
                   if(value == "gerais"){
                  normasAtuais = normasGerais;
                  atual = "GERAIS";
                } else if(value == "departamento"){
                  normasAtuais = normasDpt;
                  atual = "DEPARTAMENTO";
                }
                });
               
              },
              style:const TextStyle(color: Colors.white,),
              dropdownColor: azulEuro,
              underline: const SizedBox(),
              icon: const Padding(
                padding:  EdgeInsets.only(
                    top: 8.0), // Ajuste a posição vertical da seta
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  children: [
                   //for(int i = 0; i < normasGerais.length; i++)
                      //_buildGuiaPage(normasAtuais[i], List<Pergunta> List, i)
                   
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuiaPage(String guia, List<Pergunta> perguntas, int videoIndex) {
    double progress = (_globalProgress / 1000);

    return Column(
      children: [
        // Texto de porcentagem
        // Barra de progresso
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  color: azulEuro,
                  backgroundColor: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  minHeight: 20,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "${(progress * 10).toStringAsFixed(1)}%",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: azulEuro,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: cinza,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      guia,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "A tecnologia tem transformado radicalmente a maneira como vivemos e interagimos no mundo moderno. Desde o surgimento da internet, nossa capacidade de comunicação e acesso à informação expandiu-se exponencialmente. Hoje, é possível conectar-se com pessoas em diferentes partes do globo instantaneamente, compartilhar conhecimento e colaborar em projetos com uma facilidade antes inimaginável. "
                      "Os dispositivos móveis, como smartphones e tablets, tornaram-se extensões de nossos corpos, permitindo que permaneçamos conectados em qualquer lugar e a qualquer momento. As redes sociais, por sua vez, transformaram a maneira como nos relacionamos, criando novas formas de expressar nossas identidades e construir comunidades online. "
                      "Além disso, a inteligência artificial e o aprendizado de máquina estão revolucionando setores como saúde, finanças e educação, oferecendo soluções inovadoras para problemas complexos. No entanto, com esses avanços vêm desafios significativos, como a privacidade dos dados e o impacto da automação no mercado de trabalho. Enfrentar esses desafios de forma ética será crucial para garantir que a tecnologia continue a beneficiar a sociedade como um todo.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: cinza,
            ),
            child: PageView(
              children: perguntas.map((pergunta) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        pergunta.enunciado,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pergunta.ops.length,
                        itemBuilder: (context, index) {
                          bool isCorrect = false;
                          Color buttonColor = azulEuro;

                          if (pergunta.selectedOptionIndex == index) {
                            isCorrect = pergunta.checkAnswer(index);
                            buttonColor = isCorrect ? Colors.green : Colors.red;
                          }

                          return ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(buttonColor),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                pergunta.ops[index].texto,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              onPressed: pergunta.isAnswered
                                  ? null
                                  : () {
                                      setState(() {
                                        _globalProgress += 20;
                                        pergunta.selectedOptionIndex = index;
                                        pergunta.isAnswered = true;
                                        pergunta.isCorrect =
                                            pergunta.checkAnswer(index);
                                      });
                                    },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class Opcao {
  String texto;
  String opcao;

  Opcao({required this.texto, required this.opcao});

  factory Opcao.fromJson(Map<String, dynamic> json) {
    return Opcao(
      texto: json['texto'],
      opcao: json['opcao'],
    );
  }
}

class Pergunta {
  int id;
  String enunciado;
  String respostaCorreta;
  List<Opcao> ops;
  int? selectedOptionIndex;
  bool isAnswered = false;
  bool? isCorrect;

  Pergunta({
    required this.id,
    required this.enunciado,
    required this.respostaCorreta,
    required this.ops,
  });

  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      id: json['id'],
      enunciado: json['enunciado'],
      respostaCorreta: json['respostaCorreta'],
      ops: (json['opcoes'] as List<dynamic>)
          .map((op) => Opcao.fromJson(op))
          .toList(),
    );
  }

  bool checkAnswer(int index) {
    return ops[index].opcao == respostaCorreta;
  }
}

class Resposta{
  int? idColaborador;
  int? idPergunta;
  String? resposta;

Resposta({required this.idColaborador, required this.idPergunta, required this.resposta});

 Map<String, dynamic> toJson() {
    return {
      'colaboradorId': idColaborador,
      'perguntaId': idPergunta,
      'resposta': resposta,
    };
  }
}
