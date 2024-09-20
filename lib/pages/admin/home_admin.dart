import 'dart:convert';
import 'package:eurointegrate_app/components/cards.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/cont.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/card_graficos.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/barras_home.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pizza_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class HomeAdminScreen extends StatefulWidget {
  final String token;
  final int id;

  const HomeAdminScreen({super.key, required this.token, required this.id});

  @override
  _HomeAdminScreenState createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  late Future<DadosHome?> _dadosFuture;

  @override
  void initState() {
    super.initState();
    _dadosFuture = _getIntegracoes();
  }

  Future<DadosHome?> _getIntegracoes() async {
    await Future.delayed(const Duration(seconds: 3));
    var url = Uri.parse('$urlAPI/rh/tela-home-admin/${widget.id}');

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
        return parseDadosHome(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;

    return Scaffold(
      body: FutureBuilder<DadosHome?>(
        future: _dadosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: progressSkin(20));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados home'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('ERRO: N.E.'));
          }

          return isDesktop
              ? _buildDesktopLayout(snapshot.data!)
              : _buildMobileLayout(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(DadosHome data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BannerAdmin(
              titulo: Text(
                "Olá, ${data.nomeAdmin}".toUpperCase(),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              icon: FontAwesomeIcons.house,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: container(
                card: card(
                  iconLeft: const Icon(Icons.school, size: 40),
                  textLeft: const Text(
                    "FUNCIONÁRIOS TREINADOS",
                    style: TextStyle(
                        fontSize: 10, height: 2, fontWeight: FontWeight.bold),
                  ),
                  numberLeft: data.totalColaboradoresTreinados.toDouble(),
                  textRight: const Text(
                    "DIAS DE TREINAMENTO",
                    style: TextStyle(
                        fontSize: 10, height: 2, fontWeight: FontWeight.bold),
                  ),
                  iconRight: const Icon(Icons.calendar_month, size: 40),
                  numberRight: data.diasDeTreinamento.toDouble(),
                ),
                largura: MediaQuery.of(context).size.height * 0.95,
                altura: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChartContainer(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.65,
                  title: "QUANTIDADE DE ONBOARDINGS CRIADOS",
                  content: "TOTAL: ${data.totalProcessos}",
                  child: PizzaHome(
                    totalProcessos: data.totalProcessos,
                    seusProcessos: data.totalProcessosAdmin,
                  ),
                ),
                _buildChartContainer(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.65,
                  title: "QUANTIDADE DE ONBOARDINGS POR STATUS",
                  content: "TOTAL: ${data.totalProcessos}",
                  child: BarrasHome(
                    qtdNaoIniciado: data.qtdNaoIniciado,
                    qtdAndamento: data.qtdAndamento,
                    qtdFinalizado: data.qtFinalizado,
                  ),
                  isBar: true,
                ),
              ],
            ),
           
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(DadosHome data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BannerAdmin(
              titulo: Text(
                "Olá, ${data.nomeAdmin}".toUpperCase(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              icon: FontAwesomeIcons.house,
            ),
            const SizedBox(height: 15),

             Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: container(
                card: card(
                  iconLeft: const Icon(Icons.school, size: 40),
                  textLeft: const Text(
                    "FUNCIONÁRIOS TREINADOS",
                    style: TextStyle(
                        fontSize: 10, height: 2, fontWeight: FontWeight.bold),
                  ),
                  numberLeft: data.totalColaboradoresTreinados.toDouble(),
                  textRight: const Text(
                    "DIAS DE TREINAMENTO",
                    style: TextStyle(
                        fontSize: 10, height: 2, fontWeight: FontWeight.bold),
                  ),
                  iconRight: const Icon(Icons.calendar_month, size: 40),
                  numberRight: data.diasDeTreinamento.toDouble(),
                ),
                largura: MediaQuery.of(context).size.height * 0.95,
                altura: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
           
            const SizedBox(height: 25),
            _buildChartContainer(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.65,
                  title: "QUANTIDADE DE ONBOARDINGS CRIADOS",
                  content: "TOTAL: ${data.totalProcessos}",
                  child: PizzaHome(
                    totalProcessos: data.totalProcessos,
                    seusProcessos: data.totalProcessosAdmin,
                  ),
                ),
                const SizedBox(height: 25),
                _buildChartContainer(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.65,
                  title: "QUANTIDADE DE ONBOARDINGS POR STATUS",
                  content: "TOTAL: ${data.totalProcessos}",
                  child: BarrasHome(
                    qtdNaoIniciado: data.qtdNaoIniciado,
                    qtdAndamento: data.qtdAndamento,
                    qtdFinalizado: data.qtFinalizado,
                  ),
                  isBar: true
                ),
            
           
            const SizedBox(height: 10),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer({
    required double width,
    required double height,
    required String title,
    required String content,
    required Widget child,
    bool? isBar = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "$title",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "$content",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(height: 200, child: child),
          ),
          if(isBar!)
             const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LengendsBarra(cor: Colors.red, legenda: 'NÃO INICIADO'),
                LengendsBarra(cor: azulEuro, legenda: 'ANDAMENTO'),

              ],
            ),
          if(isBar)
             const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                            LengendsBarra(cor: Colors.green, legenda: 'FINALIZADO'),

              ],
            ),

        ],
      ),
    );
  }
}

class DadosHome {
  String nomeAdmin;
  int totalProcessos;
  int totalProcessosAdmin;
  int totalColaboradoresTreinados;
  int diasDeTreinamento;
  int qtdNaoIniciado;
  int qtFinalizado;
  int qtdAndamento;

  DadosHome({
    required this.nomeAdmin,
    required this.totalProcessos,
    required this.totalProcessosAdmin,
    required this.totalColaboradoresTreinados,
    required this.diasDeTreinamento,
    required this.qtdNaoIniciado,
    required this.qtFinalizado,
    required this.qtdAndamento,
  });

  factory DadosHome.fromJson(Map<String, dynamic> json) {
    return DadosHome(
      nomeAdmin: json['nomeAdmin'],
      totalProcessos: json['totalProcessos'],
      totalProcessosAdmin: json['totalProcessosAdmin'],
      totalColaboradoresTreinados: json['totalColaboradoresTreinados'],
      diasDeTreinamento: json['diasDeTreinamento'],
      qtdNaoIniciado: json['qtdNaoIniciado'],
      qtFinalizado: json['qtdFinalizado'],
      qtdAndamento: json['qtdAndamento'],
    );
  }
}

DadosHome parseDadosHome(String responseBody) {
  final Map<String, dynamic> json = jsonDecode(responseBody);
  return DadosHome.fromJson(json);
}

class LengendsBarra extends StatelessWidget {
  final Color cor;
  final String legenda;

  const LengendsBarra({super.key, required this.cor, required this.legenda});

  @override
  Widget build(BuildContext context) {
    return ItemLegenda(cor: cor, legenda: legenda);
  }
}
