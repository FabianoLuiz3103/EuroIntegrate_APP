import 'dart:convert';
import 'package:avatar_maker/avatar_maker.dart';
import 'package:eurointegrate_app/components/balao.dart';
import 'package:eurointegrate_app/components/cards.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/cont.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/chatbot/bot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';



class Home extends StatefulWidget {
  final String token;
  final int id;
  const Home({Key? key, required this.token, required this.id}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _jwt;
  late int _id;
   late Future<Map?> _futureData;
  @override
  void initState() {
    super.initState();
    _jwt = widget.token;
    _id = widget.id;
    _futureData = _fetchData();
  }

  Future<Map?> _fetchData() async {
    var url = Uri.parse(
        '$urlAPI/colaboradores/home/${widget.id}');
    String token = _jwt;

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
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }

    void _retryFetchData() {
    setState(() {
      _futureData = _fetchData(); // Atualiza o futuro e força a reconstrução
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map?>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    progressSkin(30),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Validando dados...",
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child:
              Column(
                children: [
                  Text("Erro ao carregar os dados..."),
                  ElevatedButton(onPressed: _retryFetchData, child: Text("Tente novamente"), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(azulEuro)),)
                ],
              )
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              Map? _dados = snapshot.data;

              String jsonOptions = _dados!['avatar'];
              Get.put(AvatarMakerController(customizedPropertyCategories: []));
              AvatarMakerController.clearAvatarMaker();
              AvatarMakerController.setJsonOptions(jsonOptions);

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 350,
                          decoration: const BoxDecoration(
                            color: azulEuro,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40,                              ),
                              SizedBox(
                                child: AvatarMakerAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 80,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Olá, ${_dados["primeiroNome"]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 280,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: container(
                              card: card(
                                iconLeft: const Icon(
                                  Icons.emoji_events,
                                  color: azulEuro,
                                  size: 40,
                                ),
                                textLeft: const Text("CONQUISTAS"),
                                numberLeft: 5.0,
                                iconRight: const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 40,
                                ),
                                textRight: const Text("PONTOS"),
                                numberRight: _dados["pontuacao"].toDouble(),
                              ),
                              largura: 300,
                              altura: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: cinza,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "INTEGRAÇÃO",
                                style: TextStyle(color: cinza),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: cinza,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${_dados["departamento"]["nome"]}"
                                              .toUpperCase(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${_dados["stsIntegracao"]}",
                                          
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "INI: ${formatarData(_dados["dataInicio"])}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "FIM: ${formatarData(_dados["dataFim"])}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: (_dados["porcProgresso"]) / 100,
                                        color: azulEuro,
                                        backgroundColor: Colors.grey,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        minHeight: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "${_dados["porcProgresso"].toStringAsFixed(1)}%",
                                      style: const TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: cinza,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "PERGUNTAS",
                                style: TextStyle(color: cinza),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: cinza,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: container(
                          card: card(
                            iconLeft: const Icon(
                              Icons.description,
                              color: azulEuro,
                              size: 40,
                            ),
                            textLeft: const Text("RESPONDIDAS"),
                            numberLeft: _dados["qtdRespondidas"].toDouble(),
                            iconRight: const Icon(
                              Icons.check_box,
                              color: Colors.green,
                              size: 40,
                            ),
                            textRight: const Text("CERTAS"),
                            numberRight: _dados["qtdCertas"].toDouble(),
                          ),
                          altura: 180,
                          largura: double.infinity),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
      floatingActionButton: CustomPaint(
        painter: BalloonPainter(),
        child: Container(
          width: 75,
          height: 75,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    icon: Image.asset(
                      "images/chat-bot.png",
                      fit: BoxFit.fill,
                    ),
                    onPressed: () {
                      _showMyDialog(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Define o raio dos cantos arredondados
        ),
        backgroundColor: Colors.transparent, // Deixa o fundo transparente
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Mantém os cantos arredondados do conteúdo
          child: Container(
            color: Colors.white, // Define a cor de fundo do conteúdo
            width: MediaQuery.of(context).size.width * 0.98, // 98% da largura da tela
            height: MediaQuery.of(context).size.height * 0.85, // 85% da altura da tela
            child: TelaBot(), // Seu widget de chatbot
          ),
        ),
      );
    },
  );
}



