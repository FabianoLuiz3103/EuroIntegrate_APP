import 'package:eurointegrate_app/components/cards.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/cont.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/barras_home.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pizza_home.dart';
import 'package:eurointegrate_app/pages/admin/components/sinal_ativo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
  
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BannerAdmin(titulo: Text(
                    "Olá, Marcos!",
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.95,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ONBOARDINGS CRIADOS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Center(child: Text("TOTAL DE PROCESSOS: XXX")),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200, // Defina a altura fixa do gráfico aqui
                  child: pizzaHome(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: container(
                    card: card(
                        iconLeft: Icon(Icons.school, size: 40),
                        textLeft: Text("FUNCIONÁRIOS TREINADOS     ",
                            style: TextStyle(fontSize: 10, height: 2)),
                        numberLeft: 80,
                        textRight: Text("    DIAS DE TREINAMENTO",
                            style: TextStyle(fontSize: 10, height: 2)),
                        iconRight: Icon(Icons.calendar_month, size: 40),
                        numberRight: 120),
                    largura: MediaQuery.of(context).size.height * 0.95,
                    altura: MediaQuery.of(context).size.height * 0.20,
                  )),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.95,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Cor da sombra
                        spreadRadius: 5, // Espalhamento da sombra
                        blurRadius: 10, // Suavidade da sombra
                        offset: const Offset(0, 3), // Deslocamento da sombra
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "QUANTIDADE DE ONBOARDINGS POR STATUS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(child: Text("TOTAL DE PROCESSOS: XXX")),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200, // Defina a altura fixa do gráfico aqui
                  child: BarrasHome(),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lengendsBarra(
                    cor: Colors.red,
                    legenda: 'NÃO INICADO',
                  ),
                  lengendsBarra(
                    cor: azulEuro,
                    legenda: 'ANDAMENTO',
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lengendsBarra(
                    cor: Colors.green,
                    legenda: 'FINALIZADO',
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class lengendsBarra extends StatelessWidget {
  final Color cor;
  final String legenda;
  const lengendsBarra({super.key, required this.cor, required this.legenda});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: cor,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            legenda,
            style: TextStyle(color: cor, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}



