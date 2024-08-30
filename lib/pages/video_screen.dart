import 'dart:async';
import 'dart:convert';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/main.dart';
import 'package:eurointegrate_app/model/api_service.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:http/http.dart' as http;

class VideoScreen extends StatefulWidget {
  final String token;
  final int id;
  const VideoScreen({super.key, required this.token, required this.id});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>{

  
  
  Future<List<List<Pergunta>>>? _fetchPerguntas;
  String? videoUm, videoDois, videoTres;
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
    var url = Uri.parse('$urlAPI/colaboradores/videos/${widget.id}');
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
        List<dynamic> data = jsonDecode(response.body);
        //print(data);
        _initVideos(data);
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


  void _initVideos(List<dynamic>? data) {
    videoUm = data![0]['linkVideo'];
    videoDois = data[1]['linkVideo'];
    videoTres = data[2]['linkVideo'];
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

  late CachedVideoPlayerController _videoPlayerController1,
      _videoPlayerController2,
      _videoPlayerController3;

  Timer? _progressTimer;
  double _globalProgress = 0.0;
  Set<int> _watchedVideos = {};
  Map<int, Timer?> _videoTimers = {};

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

@override
void initState() {
  super.initState();
  apiService = ApiService(token: widget.token, id: widget.id);
  
  _fetchPerguntas = Future.wait([
    _fetchData(),     
    _fetchDataSeq()   
  ]).then((results) {

    List<List<Pergunta>> perguntas = results[0] as List<List<Pergunta>>;
    List<dynamic> respostas = results[1];
    _initializeVideoControllers();
    _marcarPerguntasComoRespondidas(perguntas, respostas);
    return perguntas; 
  }).catchError((error) {
    print('Erro ao carregar dados: $error');
    return [];
  });
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

  void _initializeVideoControllers() {
    _videoPlayerController1 = CachedVideoPlayerController.network(videoUm!)
      ..initialize().then((_) {
        setState(() {});
        _startVideoTimer(1, _videoPlayerController1);
      });

    _videoPlayerController2 = CachedVideoPlayerController.network(videoDois!)
      ..initialize().then((_) {
        _startVideoTimer(2, _videoPlayerController2);
      });

    _videoPlayerController3 = CachedVideoPlayerController.network(videoTres!)
      ..initialize().then((_) {
        _startVideoTimer(3, _videoPlayerController3);
      });
  }

  void _startVideoTimer(
      int videoIndex, CachedVideoPlayerController videoController) {
    videoController.addListener(() {
      if (videoController.value.isPlaying) {
        if (_videoTimers[videoIndex] == null) {
          _videoTimers[videoIndex] = Timer.periodic(Duration(seconds: 1), (_) {
            if (videoController.value.isPlaying &&
                !videoController.value.isBuffering) {
              setState(() {
                _globalProgress += 2;
              });
            }
          });
        }
      } else {
        _videoTimers[videoIndex]?.cancel();
        _videoTimers[videoIndex] = null;
      }

      if (videoController.value.position ==
          videoController.value.duration) {
        setState(() {
          _watchedVideos.add(videoIndex);
        });
        _videoTimers[videoIndex]?.cancel();
        _videoTimers[videoIndex] = null;
      }
    });
  }


// // >>>>>>>>>>. DISPOSE
// @override
//   void dispose(){
//     _progressTimer?.cancel();
//     _videoPlayerController1.dispose();
//     _videoPlayerController2.dispose();
//     _videoPlayerController3.dispose();
//     _videoTimers.forEach((_, timer) => timer?.cancel());
//     super.dispose();
//   }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _videoPlayerController3.dispose();
    _videoTimers.forEach((_, timer) => timer?.cancel());
    // Use Future.microtask to ensure that these functions run in the background.
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
        title: Text("Trilha institucional"),
        backgroundColor: azulEuro,
      ),
      body: FutureBuilder<List<List<Pergunta>>>(
        future: _fetchPerguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma pergunta disponível.'));
          } else {
            List<List<Pergunta>> perguntasList = snapshot.data!;
            List<CachedVideoPlayerController> controlles = [_videoPlayerController1, _videoPlayerController2, _videoPlayerController3];

            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.85,
                child: PageView(
                  children: [
                    for (int i = 0; i < perguntasList.length; i++)
                      _buildVideoPage(perguntasList[i], controlles[i], i + 1, pgr),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildVideoPage(
    List<Pergunta> perguntas,
    CachedVideoPlayerController videoController,
    int videoIndex,
    double progressLoad
  ) {
    double progress = progressLoad + (_globalProgress / 1000);

    return Column(
      children: [
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
              SizedBox(width: 8),
              Text(
                "${(progress * 100).toStringAsFixed(1)}%",
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
        Expanded(
          child: CustomVideoPlayer(
            customVideoPlayerController: CustomVideoPlayerController(
              context: context,
              videoPlayerController: videoController,
              customVideoPlayerSettings: _customVideoPlayerSettings,
              additionalVideoSources: {
                "240p": _videoPlayerController1,
                "480p": _videoPlayerController2,
                "720p": _videoPlayerController3,
              },
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
                          bool isSelected = pergunta.selectedOptionIndex == index;
                          bool isCorrectOption = pergunta.ops[index].opcao == pergunta.respostaCorreta;

                          return ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  isSelected
                                      ? (pergunta.isCorrect! && isCorrectOption
                                          ? Colors.green
                                          : !isCorrectOption
                                              ? Colors.red
                                              : azulEuro)
                                      : azulEuro,
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                pergunta.ops[index].texto,
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              onPressed: pergunta.isAnswered
                                  ? null
                                  : () {
                                      setState(() {
                                        _globalProgress += 4;
                                        pergunta.selectedOptionIndex = index;
                                        pergunta.isAnswered = true;
                                        pergunta.isCorrect = pergunta.checkAnswer(index);
                                        if(pergunta.isCorrect!){
                                          pts += 1;
                                          qtdCertas+=1;
                                          print("Pontuação -----------------> ${pts}");
                                        }
                                        qtdRespondidas+=1;
                                        pgrEnv = (progress*100);
                                        respondidas.add(new Resposta(idColaborador: idUser, idPergunta: pergunta.id, resposta:  pergunta.ops[index].opcao));
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
