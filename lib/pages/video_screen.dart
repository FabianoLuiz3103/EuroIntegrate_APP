import 'dart:async';
import 'dart:convert';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
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

class _VideoScreenState extends State<VideoScreen> {
  Future<List<List<Pergunta>>>? _fetchPerguntas;
  String? videoUm, videoDois, videoTres;
  double pgr = 0.0;
  double pgrEnv = 0.0;
  int pts = 0;
  int qtdRespondidas = 0;
  int qtdCertas = 0;
  List<Resposta> respondidas = [];
  List<dynamic> respostas = [];
  int idUser = 0;
  late final ApiService apiService;

  //verificações
  bool mudanca = false;
  double pgrAnt = 0.0;
  int ptsAnt = 0;
  int qtdRespondidasAnt = 0;
  int qtdCertasAnt = 0;

  bool _isInitializingVideo1 = true;
  bool _isInitializingVideo2 = true;
  bool _isInitializingVideo3 = true;

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
        List<int> bytes = response.bodyBytes;
        String decodedBody = utf8.decode(bytes);
        List<dynamic> data = jsonDecode(decodedBody);
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
        pgr = data['porcProgresso'] / 100;
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
      //print("Erro na requisição: $e");
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
           // print('O valor de "perguntas" não é uma lista.');
          }
        } else {
         // print('Item não contém a chave "perguntas" ou não é um mapa.');
        }
      }
      return perguntasList;
    } else {
     // print('Dados não disponíveis ou estão vazios.');
      return [];
    }
  }

  late CachedVideoPlayerController _videoPlayerController1,
      _videoPlayerController2,
      _videoPlayerController3;

  Timer? _progressTimer;
  Set<int> _watchedVideos = {};
  Map<int, Timer?> _videoTimers = {};

  CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  @override
  void initState() {
    super.initState();
    apiService = ApiService(token: widget.token, id: widget.id);

    _fetchPerguntas =
        Future.wait([_fetchData(), _fetchDataSeq()]).then((results) {
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

  void _marcarPerguntasComoRespondidas(
      List<List<Pergunta>> perguntasList, List<dynamic> respostas) {
    for (var resposta in respostas) {
      int perguntaId = resposta['respostaId']['perguntaId'];
      String respostaDada = resposta['resposta'];
      bool foiRespondida = resposta['foiRespondida'];

      for (var sublist in perguntasList) {
        for (var pergunta in sublist) {
          if (pergunta.id == perguntaId) {
            pergunta.isAnswered = foiRespondida;
            pergunta.selectedOptionIndex =
                pergunta.ops.indexWhere((op) => op.opcao == respostaDada);
            pergunta.isCorrect =
                pergunta.checkAnswer(pergunta.selectedOptionIndex!);
          }
        }
      }
    }
  }

  void _retryFetchData() {
    setState(() {
      apiService = ApiService(token: widget.token, id: widget.id);

      _fetchPerguntas =
          Future.wait([_fetchData(), _fetchDataSeq()]).then((results) {
        List<List<Pergunta>> perguntas = results[0] as List<List<Pergunta>>;
        List<dynamic> respostas = results[1];
        _initializeVideoControllers();
        _marcarPerguntasComoRespondidas(perguntas, respostas);
        return perguntas;
      }).catchError((error) {
        print('Erro ao carregar dados: $error');
        return [];
      });
    });
  }

  void _initializeVideoControllers() {
    _videoPlayerController1 = CachedVideoPlayerController.network(videoUm!)
      ..initialize().then((_) {
        setState(() {
          _isInitializingVideo1 = false;
        });
        _startVideoTimer(1, _videoPlayerController1);
      });

    _videoPlayerController2 = CachedVideoPlayerController.network(videoDois!)
      ..initialize().then((_) {
        setState(() {
          _isInitializingVideo2 = false;
        });
        _startVideoTimer(2, _videoPlayerController2);
      });

    _videoPlayerController3 = CachedVideoPlayerController.network(videoTres!)
      ..initialize().then((_) {
        setState(() {
          _isInitializingVideo3 = false;
        });
        _startVideoTimer(3, _videoPlayerController3);
      });
  }

  void _startVideoTimer(
      int videoIndex, CachedVideoPlayerController videoController) {
    videoController.addListener(() {
      if (videoController.value.isPlaying) {
        if (_videoTimers[videoIndex] == null) {
          _videoTimers[videoIndex] = Timer.periodic(const Duration(seconds: 1), (_) {
            if (videoController.value.isPlaying &&
                !videoController.value.isBuffering) {
              setState(() {
                pgr += (2 / 1000);
                pgrEnv = (pgr * 100);
                verificarMudanca();
              });
            }
          });
        }
      } else {
        _videoTimers[videoIndex]?.cancel();
        _videoTimers[videoIndex] = null;
      }

      if (videoController.value.position == videoController.value.duration) {
        setState(() {
          _watchedVideos.add(videoIndex);
        });
        _videoTimers[videoIndex]?.cancel();
        _videoTimers[videoIndex] = null;
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _videoPlayerController3.dispose();
    _videoTimers.forEach((_, timer) => timer?.cancel());
    // Use Future.microtask to ensure that these functions run in the background.
    if (mudanca) {
      Future.microtask(() async {
        //print(pgrEnv);
        await apiService.enviarDados(pgrEnv, pts, qtdRespondidas, qtdCertas);
        await apiService.enviarRespostas(respondidas);
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;
    final PageController _pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trilha institucional"),
        backgroundColor: azulEuro,
      ),
      body: FutureBuilder<List<List<Pergunta>>>(
        future: _fetchPerguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: progressSkin(30),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [
                const Text("Erro ao carregar os dados..."),
                ElevatedButton(
                  onPressed: _retryFetchData,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(azulEuro)),
                  child: const Text("Tente novamente"),
                )
              ],
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma pergunta disponível.'));
          } else {
            List<List<Pergunta>> perguntasList = snapshot.data!;
            List<CachedVideoPlayerController> controlles = [
              _videoPlayerController1,
              _videoPlayerController2,
              _videoPlayerController3
            ];
            int controllerCount = controlles.length;
            return Center(
              child: SizedBox(
                width: isDesktop
                    ? MediaQuery.of(context).size.width * 1
                    : MediaQuery.of(context).size.width * 0.90,
                height: isDesktop
                    ? MediaQuery.of(context).size.width * 1
                    : MediaQuery.of(context).size.height * 0.85,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      children: [
                        for (int i = 0;
                            i < controllerCount && i < perguntasList.length;
                            i++)
                          _buildVideoPage(
                              perguntasList[i], controlles[i], i + 1),
                      ],
                    ),
                    isDesktop
                        ? Positioned(
                            left: 10,
                            top: MediaQuery.of(context).size.height / 2 - 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: azulEuro,
                                size: 30,
                              ),
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                    isDesktop
                        ? Positioned(
                            right: 10,
                            top: MediaQuery.of(context).size.height / 2 - 20,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: azulEuro,
                                size: 30,
                              ),
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildVideoPage(List<Pergunta> perguntas,
      CachedVideoPlayerController videoController, int videoIndex) {
    bool isInitializing = (videoIndex == 1 && _isInitializingVideo1) ||
        (videoIndex == 2 && _isInitializingVideo2) ||
        (videoIndex == 3 && _isInitializingVideo3);

    final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;
    final videoHeight = isDesktop
        ? MediaQuery.of(context).size.height * 0.5
        : MediaQuery.of(context).size.height * 0.85;
    final videoWidth = isDesktop
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.height * 0.90;

    final PageController _pageController = PageController();
    int _currentPage = 0;

    void _nextPage() {
      if (_currentPage < perguntas.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage++;
        });
      }
    }

    void _previousPage() {
      if (_currentPage > 0) {
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage--;
        });
      }
    }

    return isDesktop
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    SizedBox(width: 30),
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
              Padding(
                padding: const EdgeInsets.only(right: 100, top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: videoWidth, // Ajuste a largura conforme necessário
                      height:
                          videoHeight, // Ajuste a altura conforme necessário
                      child: isInitializing
                          ? Center(child: progressSkin(30))
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: videoController.value.size.width,
                                height: videoController.value.size.height,
                                child: CustomVideoPlayer(
                                  customVideoPlayerController:
                                      CustomVideoPlayerController(
                                    context: context,
                                    videoPlayerController: videoController,
                                    customVideoPlayerSettings:
                                        _customVideoPlayerSettings =
                                            const CustomVideoPlayerSettings(
                                      showFullscreenButton:
                                          true, // Habilita o botão fullscreen
                                      showSeekButtons: true,
                                    ),
                                    additionalVideoSources: {
                                      "240p": _videoPlayerController1,
                                      "480p": _videoPlayerController2,
                                      "720p": _videoPlayerController3,
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ),

                    // Container para o PageView
                    Expanded(
                      child: Container(
                        height: videoHeight, // Definindo a altura do PageView
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: cinza,
                        ),
                        child: Stack(
                          children: [
                            PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              children: perguntas.map((pergunta) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        pergunta.enunciado,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: pergunta.ops.length,
                                        itemBuilder: (context, index) {
                                          bool isSelected =
                                              pergunta.selectedOptionIndex ==
                                                  index;
                                          bool isCorrectOption =
                                              pergunta.ops[index].opcao ==
                                                  pergunta.respostaCorreta;

                                          return ListTile(
                                            title: TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  isSelected
                                                      ? (pergunta.isCorrect! &&
                                                              isCorrectOption
                                                          ? Colors.green
                                                          : !isCorrectOption
                                                              ? Colors.red
                                                              : azulEuro)
                                                      : azulEuro,
                                                ),
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                pergunta.ops[index].texto,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              onPressed: pergunta.isAnswered
                                        ? null
                                        : () {
                                            setState(() {
                                              pgr += (4 / 1000);
                                              pergunta.selectedOptionIndex =
                                                  index;
                                              pergunta.isAnswered = true;
                                              pergunta.isCorrect =
                                                  pergunta.checkAnswer(index);
                                              if (pergunta.isCorrect!) {
                                                pts += 1;
                                                qtdCertas += 1;
                                              }
                                              qtdRespondidas += 1;
                                              pgrEnv = (pgr * 100);
                                              respondidas.add(new Resposta(
                                                  idColaborador: idUser,
                                                  idPergunta: pergunta.id,
                                                  resposta: pergunta
                                                      .ops[index].opcao));
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
                            Positioned(
                              left: 10,
                              top: MediaQuery.of(context).size.height / 2 - 290,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: azulEuro,
                                  size: 20,
                                ),
                                onPressed: _previousPage,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: MediaQuery.of(context).size.height / 2 - 290,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: azulEuro,
                                  size: 20,
                                ),
                                onPressed: _nextPage,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            children: [
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
                    SizedBox(width: 8),
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
              isDesktop
                  ? Container(
                      width: videoWidth,
                      height: videoHeight,
                      child: isInitializing
                          ? Center(child: progressSkin(30))
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: videoController.value.size.width,
                                height: videoController.value.size.height,
                                child: CustomVideoPlayer(
                                  customVideoPlayerController:
                                      CustomVideoPlayerController(
                                    context: context,
                                    videoPlayerController: videoController,
                                    customVideoPlayerSettings:
                                        _customVideoPlayerSettings =
                                            const CustomVideoPlayerSettings(
                                      showFullscreenButton:
                                          true, // Habilita o botão fullscreen
                                      showSeekButtons: true,
                                    ),
                                    additionalVideoSources: {
                                      "240p": _videoPlayerController1,
                                      "480p": _videoPlayerController2,
                                      "720p": _videoPlayerController3,
                                    },
                                  ),
                                ),
                              ),
                            ),
                    )
                  : Expanded(
                      child: isInitializing
                          ? Center(child: progressSkin(30))
                          : CustomVideoPlayer(
                              customVideoPlayerController:
                                  CustomVideoPlayerController(
                                context: context,
                                videoPlayerController: videoController,
                                customVideoPlayerSettings:
                                    _customVideoPlayerSettings =
                                        const CustomVideoPlayerSettings(
                                  showFullscreenButton:
                                      true, // Habilita o botão fullscreen
                                  showSeekButtons: true,
                                ),
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
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: pergunta.ops.length,
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    pergunta.selectedOptionIndex == index;
                                bool isCorrectOption =
                                    pergunta.ops[index].opcao ==
                                        pergunta.respostaCorreta;

                                return ListTile(
                                  title: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        isSelected
                                            ? (pergunta.isCorrect! &&
                                                    isCorrectOption
                                                ? Colors.green
                                                : !isCorrectOption
                                                    ? Colors.red
                                                    : azulEuro)
                                            : azulEuro,
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
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
                                              pgr += (4 / 1000);
                                              pergunta.selectedOptionIndex =
                                                  index;
                                              pergunta.isAnswered = true;
                                              pergunta.isCorrect =
                                                  pergunta.checkAnswer(index);
                                              if (pergunta.isCorrect!) {
                                                pts += 1;
                                                qtdCertas += 1;
                                              }
                                              qtdRespondidas += 1;
                                              pgrEnv = (pgr * 100);
                                              respondidas.add(new Resposta(
                                                  idColaborador: idUser,
                                                  idPergunta: pergunta.id,
                                                  resposta: pergunta
                                                      .ops[index].opcao));
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

class Resposta {
  int? idColaborador;
  int? idPergunta;
  String? resposta;

  Resposta(
      {required this.idColaborador,
      required this.idPergunta,
      required this.resposta});

  Map<String, dynamic> toJson() {
    return {
      'colaboradorId': idColaborador,
      'perguntaId': idPergunta,
      'resposta': resposta,
    };
  }
}
