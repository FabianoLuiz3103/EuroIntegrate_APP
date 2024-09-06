import 'package:eurointegrate_app/components/cards.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/cont.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/card_graficos.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/barras_home.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pizza_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    "OLÁ, MARCOS",
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  icon: FontAwesomeIcons.house,
                  ),
              const SizedBox(height: 10),
              const CardGraficos(title: "ONBOARDINGS CRIADOS", subtitle: "TOTAL DE PROCESSOS: XXX",),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
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
                        iconLeft: const Icon(Icons.school, size: 40),
                        textLeft: const Text("FUNCIONÁRIOS TREINADOS     ",
                            style: TextStyle(fontSize: 10, height: 2)),
                        numberLeft: 80,
                        textRight:const Text("    DIAS DE TREINAMENTO",
                            style: TextStyle(fontSize: 10, height: 2)),
                        iconRight:const  Icon(Icons.calendar_month, size: 40),
                        numberRight: 120),
                    largura: MediaQuery.of(context).size.height * 0.95,
                    altura: MediaQuery.of(context).size.height * 0.20,
                  )),
              const SizedBox(height: 10),
              const CardGraficos(title: "QUANTIDADE DE ONBOARDINGS POR STATUS", subtitle: "TOTAL DE PROCESSOS: XXX",),
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
              const SizedBox(
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
    return ItemLegenda(cor: cor, legenda: legenda);
  }
}

