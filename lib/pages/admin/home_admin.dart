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

class HomeAdminScreen extends StatelessWidget {
  final String token;
  final int id;
  const HomeAdminScreen({super.key, required this.token, required this.id});


  @override
  Widget build(BuildContext context) {
    Future<DadosHome?> _getIntegracoes() async{
     await Future.delayed(const Duration(seconds: 3));
    var url = Uri.parse('$urlAPI/rh/tela-home-admin/$id');

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
        return parseDadosHome(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }

  }
  
    
    return Scaffold(
      body: FutureBuilder<DadosHome?>(
        future: _getIntegracoes(),
        builder: (context, snapshot){
           if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: progressSkin(20), // Removendo SizedBox e Align desnecessários
        );
      } else if (snapshot.hasError) {
        return const Center(
          child: Text('Erro ao carregar dados home'),
        );
      } else if (!snapshot.hasData || snapshot.data! == null) {
        return const Center(
          child: Text('ERRO: N.E.'),
        );
      }


          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 BannerAdmin(titulo: Text(
                      "Olá, ${snapshot.data!.nomeAdmin}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                    ),
                    icon: FontAwesomeIcons.house,
                    ),
                const SizedBox(height: 10),
                CardGraficos(title: "ONBOARDINGS CRIADOS", subtitle: "TOTAL DE PROCESSOS: ${snapshot.data!.totalProcessos}",),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 200,
                    child: PizzaHome(totalProcessos: snapshot.data!.totalProcessos, seusProcessos: snapshot.data!.totalProcessosAdmin,),
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
                              style: TextStyle(fontSize: 10, height: 2, fontWeight: FontWeight.bold)),
                          numberLeft: snapshot.data!.totalColaboradoresTreinados.toDouble(),
                          textRight:const Text("    DIAS DE TREINAMENTO",
                              style: TextStyle(fontSize: 10, height: 2, fontWeight: FontWeight.bold)),
                          iconRight:const  Icon(Icons.calendar_month, size: 40),
                          numberRight: snapshot.data!.diasDeTreinamento.toDouble()),
                      largura: MediaQuery.of(context).size.height * 0.95,
                      altura: MediaQuery.of(context).size.height * 0.25,
                    )),
                const SizedBox(height: 10),
                CardGraficos(title: "QUANTIDADE DE ONBOARDINGS POR STATUS", subtitle: "TOTAL DE PROCESSOS: ${snapshot.data!.totalProcessos}",),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 200, // Defina a altura fixa do gráfico aqui
                    child: BarrasHome(
                      qtdNaoIniciado: snapshot.data!.qtdNaoIniciado,
                      qtdAndamento: snapshot.data!.qtdAndamento,
                      qtdFinalizado: snapshot.data!.qtFinalizado,
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                    LengendsBarra(
                      cor: Colors.red,
                      legenda: 'NÃO INICADO',
                    ),
                    LengendsBarra(
                      cor: azulEuro,
                      legenda: 'ANDAMENTO',
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LengendsBarra(
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
        );

        },
        
      ),
    );
  }
}


class DadosHome{
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
    required this.qtdAndamento
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
       qtdAndamento: json['qtdAndamento']
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

