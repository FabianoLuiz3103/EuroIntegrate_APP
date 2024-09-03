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
  State<GuiaScreen> createState() => _GuiaScreenState();
}

class _GuiaScreenState extends State<GuiaScreen> {


  List<DropdownMenuItem<String>> items = [
   const DropdownMenuItem(
      value: "gerais",
      child: Text("GERAIS"),
    ),
    const DropdownMenuItem(value: "departamento", child: Text("DEPARTAMENTO"))
  ];
  List<Map<String, dynamic>> normasGerais = [];
   List<Map<String, dynamic>> normasDpt = [];
  List<Map<String, dynamic>> normasAtuais = [];
  List<List<Pergunta>> perguntasDepartamento = [];
    List<List<Pergunta>> perguntasGerais = [];
    List<List<Pergunta>> perguntasAtuais = [];
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

    //verificações
  bool mudanca = false;
  double pgrAnt = 0.0;
  int ptsAnt = 0;
  int qtdRespondidasAnt = 0;
  int qtdCertasAnt = 0;



Future<Map<String, List<List<Pergunta>>>> _fetchData() async {
  var url1 = Uri.parse('$urlAPI/colaboradores/normas-departamento/${widget.id}');
  var url2 = Uri.parse('$urlAPI/colaboradores/normas-gerais');
  String token = widget.token;

  try {
    final response1Future = http.get(
      url1,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    final response2Future = http.get(
      url2,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    final responses = await Future.wait([response1Future, response2Future]);

    // Processa a resposta da primeira requisição
    final response1 = responses[0];
    List<List<Pergunta>> perguntasDepartamento = [];
    if (response1.statusCode == 200) {
      List<dynamic> data1 = jsonDecode(utf8.decode(response1.bodyBytes));
      perguntasDepartamento = _inicializarPerguntas(data1);

      _initNormasDPT(
        data1
          .map((item) => item['normas'])
          .whereType<Map<String, dynamic>>()
          .cast<Map<String, dynamic>>()
          .toList()
      );
    } else {
      throw Exception('Failed to load data from url1');
    }

    // Processa a resposta da segunda requisição
    final response2 = responses[1];
    List<List<Pergunta>> perguntasGerais = [];
    if (response2.statusCode == 200) {
      List<dynamic> data2 = jsonDecode(utf8.decode(response2.bodyBytes));
      perguntasGerais = _inicializarPerguntas(data2);

      _initNormasGerais(
        data2
          .map((item) => item['normas'])
          .whereType<Map<String, dynamic>>()
          .cast<Map<String, dynamic>>()
          .toList()
      );
    } else {
      throw Exception('Failed to load data from url2');
    }

    // Retorna as perguntas de ambas as requisições com suas respectivas chaves
    return {
      "departamento": perguntasDepartamento,
      "gerais": perguntasGerais,
    };

  } catch (e) {
    print("Erro na requisição: $e");
    return {
      "departamento": [],
      "gerais": [],
    };
  }
}


  Future<List<dynamic>> _fetchDataSeq() async {
    var url = Uri.parse('$urlAPI/colaboradores/dados-aux/${widget.id}');
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
        
        //variáveis para verificar se teve mudança
        pgrAnt = pgr;
        ptsAnt = pts;
        qtdRespondidasAnt = qtdRespondidas;
        qtdCertasAnt = qtdCertas;
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

void _initNormasDPT(List<Map<String, dynamic>> data){
  normasDpt = data;
}

void _initNormasGerais(List<Map<String, dynamic>> data){
  normasGerais = data;
}

@override
void initState() {
  super.initState();
  apiService = ApiService(token: widget.token, id: widget.id);
  atual = "DEPARTAMENTO";
  _fetchPerguntas = Future.wait([
    _fetchData(),  
    _fetchDataSeq(),
  ]).then((results) {
    Map<String, List<List<Pergunta>>> perguntasMap = results[0] as Map<String, List<List<Pergunta>>>;
    perguntasDepartamento = perguntasMap["departamento"]!;
    perguntasGerais = perguntasMap["gerais"]!;
    perguntasAtuais = perguntasDepartamento;
    normasAtuais = normasDpt;
    List<dynamic> respostas = results[1] as List<dynamic>;
    List<List<Pergunta>> todasPerguntas = [...perguntasDepartamento, ...perguntasGerais];
    _marcarPerguntasComoRespondidas(todasPerguntas, respostas);

    return todasPerguntas; 
  }).catchError((error) {
    print('Erro ao carregar dados: $error');
    return [];
  });
}

void verificarMudanca() {
    if (pgr != pgrAnt) {
      mudanca = true;
      pgrAnt = pgrEnv;
    }
    if (pts != ptsAnt) {
      mudanca = true;
      ptsAnt = pts;
    }
    if (qtdRespondidas != qtdRespondidasAnt) {
      mudanca = true;
      qtdRespondidasAnt = qtdRespondidas;
    }
    if (qtdCertas != qtdCertasAnt) {
      mudanca = true;
      qtdCertasAnt = qtdCertas;
    }
  }


    void _marcarPerguntasComoRespondidas(List<List<Pergunta>> perguntasList, List<dynamic> respostas) {
  for (var resposta in respostas) {
    int perguntaId = resposta['respostaId']['perguntaId'];
    String respostaDada = resposta['resposta'];
    bool foiRespondida = resposta['foiRespondida'];

    for (var sublist in perguntasList) {
      for (var pergunta in sublist) {
        if (pergunta.id == perguntaId) {
          pergunta.isAnswered = foiRespondida;
          pergunta.selectedOptionIndex = pergunta.ops.indexWhere((op) => op.opcao == respostaDada);
          pergunta.isCorrect = pergunta.checkAnswer(pergunta.selectedOptionIndex!);
        }
      }
    }
  }
}

   @override
  void dispose() {
  if(mudanca){
          Future.microtask(() async {
      await apiService.enviarDados(pgrEnv, pts, qtdRespondidas, qtdCertas);
      await apiService.enviarRespostas(respondidas);
    });
    } 

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
                  perguntasAtuais = perguntasGerais;
                  atual = "GERAIS";
                } else if(value == "departamento"){
                  normasAtuais = normasDpt;
                  perguntasAtuais = perguntasDepartamento;
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
      body:  FutureBuilder<List<List<Pergunta>>>(
  future: _fetchPerguntas,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('Nenhuma pergunta disponível.'));
    } else {
      List<List<Pergunta>> perguntasList = perguntasAtuais;
      int normasCount = normasAtuais.length;
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.85,
          child: PageView(
            children: [
              for (int i = 0; i < normasCount && i < perguntasList.length; i++)
                _buildGuiaPage(perguntasList[i], normasAtuais[i]['nome'], normasAtuais[i]['descricao'], i + 1),
            ],
          ),
        ),
      );
    }
  },
),

    );
  }

  Widget _buildGuiaPage(List<Pergunta> perguntas, String nome, String descricao, int guiaIndex
  ) {


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
                  value: pgr,
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
                "${(pgr * 100).toStringAsFixed(1)}%",
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
                      nome,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      descricao,
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
                                  : ()  {
                                      setState(() {
                                       pgr += (4/1000);
                                        pergunta.selectedOptionIndex = index;
                                        pergunta.isAnswered = true;
                                        pergunta.isCorrect = pergunta.checkAnswer(index);
                                        if(pergunta.isCorrect!){
                                          pts += 1;
                                          qtdCertas+=1;
                                        }
                                        qtdRespondidas+=1;
                                        pgrEnv = (pgr * 100);
                                        respondidas.add(new Resposta(idColaborador: idUser, idPergunta: pergunta.id, resposta:  pergunta.ops[index].opcao));
                                        verificarMudanca();
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


class Norma{
  String nome;
  String descricao;

  Norma({required this.nome, required this.descricao});
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
