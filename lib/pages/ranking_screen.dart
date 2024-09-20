import 'dart:convert';

import 'package:avatar_maker/avatar_maker.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class RankingPage extends StatefulWidget {
  final String token;
  final bool isAdmin;
  const RankingPage({super.key, required this.token, required this.isAdmin});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late Future<List<Departamento>?> _futureDepts;
  Departamento? _departamentoSelecionado;
  late Future<List<Result>>? _results;

  Future<List<Departamento>> fetchDepartamentos() async {
    await Future.delayed(const Duration(seconds: 2));

    List<Map<String, dynamic>> departamentosJson = [
      {'id': 1, 'nome': 'Recursos Humanos'},
      {'id': 2, 'nome': 'Financeiro'},
      {'id': 3, 'nome': 'Tecnologia da Informação'},
      {'id': 4, 'nome': 'Marketing'},
    ];

    return departamentosJson
        .map((json) => Departamento.fromJson(json))
        .toList();
  }

  Future<List<Result>> _getResults() async {
    await Future.delayed(const Duration(seconds: 3));
    var url = Uri.parse('$urlAPI/ranking');

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
        List<Result> results = parseResult(utf8.decode(response.bodyBytes));
        // Ordena os resultados pela pontuação (do maior para o menor)
        results.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));
        return results;
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return [];
    }
  }


  @override
  void initState() {
    super.initState();
    _futureDepts = fetchDepartamentos();
    _results = _getResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAdmin
          ? null
          : AppBar(
              title: const Text('Ranking'),
              backgroundColor: azulEuro,
            ),
      body: FutureBuilder<List<Result>?>(
        future: _results,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: progressSkin(20));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar ranking'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum resultado encontrado.'));
          }

          final List<Result> allPlayers = snapshot.data!;
          final List<Result> top3 = allPlayers.take(3).toList();
          final List<Result> generalRanking = allPlayers.skip(3).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                if (widget.isAdmin)
                  BannerAdmin(
                    titulo: Text(
                      "ranking".toUpperCase(),
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    icon: FontAwesomeIcons.medal,
                  ),
                Top3PlayersWidget(
                  top3: top3,
                ),
                const SizedBox(height: 20),
                _buildGeneralRanking(generalRanking),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildGeneralRanking(List<Result> generalRanking) {
     final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;
    return Padding(
      padding: EdgeInsets.only(left: isDesktop ? 70 : 16, right: isDesktop ? 70 : 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: generalRanking.length,
        itemBuilder: (context, index) {
          final player = generalRanking[index];
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  leading: AvatarPlayer(avatar: player.avatar),
                  title: Text(player.primeiroNome),
                  subtitle: Text('Pontuação: ${player.pontuacao} '),
                  trailing: IconButton(
                    onPressed: () {
                      showConfirmacaoCadastroDetails(player, context);
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Result {
  String avatar;
  String primeiroNome;
  String sobrenome;
  int pontuacao;
  Departamento departamento;
  String status;
  DateTime dataInicio;
  DateTime dataFim;

  Result({
    required this.avatar,
    required this.primeiroNome,
    required this.sobrenome,
    required this.pontuacao,
    required this.departamento,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      avatar: json['avatar'],
      primeiroNome: json['primeiroNome'],
      sobrenome: json['sobrenome'],
      pontuacao: json['pontuacao'],
      departamento: Departamento.fromJson(json['departamento']),
      status: json['stsIntegracao'],
      dataInicio: DateTime.parse(json['dataInicio']),
      dataFim: DateTime.parse(json['dataFim']),
    );
  }
}

List<Result> parseResult(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Result>((json) => Result.fromJson(json)).toList();
}

class Departamento {
  int id;
  String nome;

  Departamento({required this.id, required this.nome});

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(id: json["id"], nome: json["nome"]);
  }
}

List<Departamento> parseDepartamento(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Departamento>((json) => Departamento.fromJson(json))
      .toList();
}

class PlayerWithAvatar {
  final Result player;
  String? avatarSvg;

  PlayerWithAvatar({required this.player, this.avatarSvg});
}

class Top3PlayersWidget extends StatefulWidget {
  final List<Result> top3;

  const Top3PlayersWidget({
    required this.top3,
  });

  @override
  _Top3PlayersWidgetState createState() => _Top3PlayersWidgetState();
}

class _Top3PlayersWidgetState extends State<Top3PlayersWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPlayerColumn(1, 70, 'assets/animation/silver.json'),
        _buildPlayerColumn(0, 120, 'assets/animation/gold.json', isFirst: true),
        _buildPlayerColumn(2, 70, 'assets/animation/bronze.json'),
      ],
    );
  }

  Widget _buildPlayerColumn(int playerIndex, double size, String medal,
      {bool isFirst = false}) {
    final playerWithAvatar = widget.top3[playerIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isFirst) const SizedBox(height: 150),
        if (isFirst)
          Container(
            color: Colors.transparent,
            child: Lottie.asset(
              'assets/animation/primeiro.json',
            ),
          ),
        // Exibe o jogador se o avatar já estiver carregado
        if (playerWithAvatar != null)
          GestureDetector(
            onTap: () {
              showConfirmacaoCadastroDetails(playerWithAvatar, context);
            },
            child: TopPlayerWidget(
              player: playerWithAvatar,
              size: size,
              medal: medal,
              prm: isFirst ? true : false,
            ),
          )
        else
          CircularProgressIndicator(), // Mostra um loader até o avatar carregar
      ],
    );
  }
}

class TopPlayerWidget extends StatelessWidget {
  final Result player;
  final double size;
  final String medal;
  final bool prm;

  const TopPlayerWidget({
    required this.player,
    required this.size,
    required this.medal,
    required this.prm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.string(
          player.avatar,
          width: prm ? 120 : 80,
          height: prm ? 120 : 80,
        ),
        Text(player.primeiroNome),
        Text('Pontuação: ${player.pontuacao}'),
        Lottie.asset(medal, width: 30, height: 30),
      ],
    );
  }
}

class AvatarPlayer extends StatefulWidget {
  final String avatar;

  const AvatarPlayer({required this.avatar});

  @override
  _AvatarPlayerState createState() => _AvatarPlayerState();
}

class _AvatarPlayerState extends State<AvatarPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;

    return Column(
      children: [
        // Exibe o avatar SVG carregado ou um indicador de progresso enquanto aguarda o carregamento
        SvgPicture.string(
          widget.avatar,
          width: 40,
          height: 40,
        ),
      ],
    );
  }
}

String _toBrDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

 Future showConfirmacaoCadastroDetails(Result dados, BuildContext context) {
    Future<Result?> _fetchResult() async {
      await Future.delayed(const Duration(seconds: 2));
      return dados;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 200,
            height: 500,
            child: FutureBuilder<Result?>(
              future: _fetchResult(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: 150,
                    child: Align(
                      alignment: Alignment.center,
                      child: progressSkin(20),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Erro ao carregar detalhes');
                } else if (!snapshot.hasData || snapshot.data! == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ERRO: Nenhum dado disponível.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  });
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SvgPicture.string(
                          snapshot.data!.avatar,
                          width: 60,
                          height: 60,
                        ),
                      ),
                      Divider(color: cinza),
                      Center(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("NOME")),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${snapshot.data!.primeiroNome.toUpperCase()} ${snapshot.data!.sobrenome.toUpperCase()}')
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(color: cinza),
                      Center(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("PONTOS")),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${snapshot.data!.pontuacao}'),
                                Icon(Icons.star, color: Colors.amber),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(color: cinza),
                      Center(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("DEPARTAMENTO")),
                            ),
                            Text(snapshot.data!.departamento.nome.toUpperCase(),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      Divider(color: cinza),
                      Center(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("STATUS")),
                            ),
                            Text(snapshot.data!.status),
                          ],
                        ),
                      ),
                      Divider(color: cinza),
                      Center(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("INÍCIO - FIM")),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(_toBrDate(snapshot.data!.dataInicio)),
                                Text(_toBrDate(snapshot.data!.dataFim))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
