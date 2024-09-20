import 'dart:convert';

import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/card_graficos.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/barras_dash.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/linear_dash.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pie_dash.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pie_dash_dois.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class DashsIntegracaoScreen extends StatefulWidget {
  final String token;
  const DashsIntegracaoScreen({super.key, required this.token});

  @override
  State<DashsIntegracaoScreen> createState() => _DashsIntegracaoScreenState();
}

class _DashsIntegracaoScreenState extends State<DashsIntegracaoScreen> {
  bool _isLoading = true;
  String selectedYearUm = '2024'; // Ano padrão selecionado
  String selectedYearDois = '2024'; // Ano padrão selecionado
  String selectedYearTres = '2024'; // Ano padrão selecionado
  String selectedYearQuatro = '2024';
  String selectedYearCinco = '2024';
  final List<String> years = ['2022', '2023', '2024']; // Anos disponíveis

  Map<String, List<int>> mapAnosIdades = {};
  Map<String, List<int>> mapAnosRespondidas = {};
  Map<String, List<int>> mapAnosCertas = {};
  Map<String, Map<String, double>> mapProgressoMes = {};
  Map<String, Map<String, double>> mapAcertosMes = {};
  Map<String, List<FlSpot>> dataByYear = {};

  Future<void> _getDadosDash() async {
    await Future.delayed(const Duration(seconds: 3));
    var url = Uri.parse('$urlAPI/rh/dash');
    String tkn = widget.token;

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $tkn",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        parseJsonData(utf8.decode(response.bodyBytes));
      } else {}
    } catch (e) {
      print("Erro na requisição: $e");
    } finally {
      setState(() {
        _isLoading =
            false; // Atualizar o estado para indicar que o carregamento foi concluído
      });
    }
  }

  void parseJsonData(String jsonString) {
    final jsonData = json.decode(jsonString) as List<dynamic>;

    // Limpa os mapas antes de adicionar novos dados
    mapAnosIdades.clear();
    mapAnosRespondidas.clear();
    mapAnosCertas.clear();
    mapProgressoMes.clear();
    mapAcertosMes.clear();

    // Mapeamento dos meses para índices
    final monthIndex = {
      'JANUARY': 0,
      'FEBRUARY': 1,
      'MARCH': 2,
      'APRIL': 3,
      'MAY': 4,
      'JUNE': 5,
      'JULY': 6,
      'AUGUST': 7,
      'SEPTEMBER': 8,
      'OCTOBER': 9,
      'NOVEMBER': 10,
      'DECEMBER': 11,
    };

    for (var item in jsonData) {
      final anos = (item['anosIntegracao'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      final idades =
          (item['idades'] as List<dynamic>).map((e) => e as int).toList();
      final respondidas =
          (item['respondidas'] as List<dynamic>).map((e) => e as int).toList();
      final certas =
          (item['certas'] as List<dynamic>).map((e) => e as int).toList();
      final progresso = item['mediaPorgresso'] as Map<String, dynamic>;
      final acertos = item['mediaAcertos'] as Map<String, dynamic>;

      // Converta `quantidadeProcessos` para o formato desejado
      final quantidadeProcessos =
          item['quantidadeProcessos'] as Map<String, dynamic>;
      for (var ano in anos) {
        // Adiciona idades, respondidas e certas aos mapas
        mapAnosIdades[ano] = idades;
        mapAnosRespondidas[ano] = respondidas;
        mapAnosCertas[ano] = certas;
        mapProgressoMes[ano] =
            progresso.map((k, v) => MapEntry(k, v.toDouble()));
        mapAcertosMes[ano] = acertos.map((k, v) => MapEntry(k, v.toDouble()));

        // Converta `quantidadeProcessos` para `FlSpot`
        dataByYear[ano] = monthIndex.entries.map((entry) {
          final month = entry.key;
          final index = entry.value.toDouble();
          final value = (quantidadeProcessos[month] as int?) ?? 0;
          return FlSpot(index, value.toDouble());
        }).toList();
      }
    }
  }

  // Variáveis para o Dropdown de ano e mês
  String selectedYearBarra = '2024'; // Ano padrão para o gráfico de barras
  String? selectedMonth = '';
  @override
  void initState() {
    super.initState();
    _getDadosDash();
  }

  final List<String> months = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ]; // Meses disponíveis

  List<FlSpot> getBarFilteredDataByYear() {
    // Recupera os dados apenas para o ano selecionado
    final List<FlSpot>? yearData = dataByYear[selectedYearTres];
    if (yearData != null) {
      return yearData;
    }
    // Retorna uma lista vazia quando não há dados para o ano selecionado
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;
    if (_isLoading) {
      // Exibe um indicador de carregamento enquanto os dados estão sendo carregados
      return Scaffold(
        body: Center(
          child: progressSkin(20),
        ),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: isDesktop
              ?

              //webapp
              Column(
                  children: [
                    const BannerAdmin(
                      titulo: Text(
                        "DASHBOARDS",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      isIconButton: false,
                      icon: (FontAwesomeIcons.chartPie),
                    ),
                    const SizedBox(height: 30),

                    const SizedBox(
                      height: 30,
                    ),
                    // Filtro por ano para PieDash
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.70,
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
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                    child: Text(
                                  "FAIXA ETÁRIA DOS NOVOS COLABORADORES POR ANO",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: isDesktop
                                      ? MainAxisAlignment.spaceEvenly
                                      : MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "FILTRAR POR ANO:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedYearQuatro,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedYearQuatro = newValue!;
                                        });
                                      },
                                      items: years.map((String year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      underline: const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: SizedBox(
                                  height: 200,
                                  child: PieDash(
                                      idades: mapAnosIdades,
                                      selectedYear:
                                          selectedYearQuatro), // Passando o ano selecionado para o gráfico de pizza
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.70,
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
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                    child: Text(
                                  "QUESTÕES CERTAS E ERRADAS POR ANO",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: isDesktop
                                      ? MainAxisAlignment.spaceEvenly
                                      : MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "FILTRAR POR ANO:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedYearCinco,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedYearCinco = newValue!;
                                        });
                                      },
                                      items: years.map((String year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      underline: const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: SizedBox(
                                  height: 200,
                                  child: PieDashDois(
                                    anosRespondidas: mapAnosRespondidas,
                                    anosCertas: mapAnosCertas,
                                    selectedYear: selectedYearCinco,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.99,
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
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                    child: Text(
                                  "MÉDIA DE PROGRESSO NO ONBOARDING POR MÊS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: isDesktop
                                      ? MainAxisAlignment.spaceEvenly
                                      : MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "FILTRAR POR ANO:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedYearUm,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedYearUm = newValue!;
                                        });
                                      },
                                      items: years.map((String year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      underline: const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: SizedBox(
                                  height: 400,
                                  child: LinearDash(
                                      selectedYear: selectedYearUm,
                                      progressoMes: mapProgressoMes,
                                    //  msgEmpty: dataByYear[selectedYearUm]!.isEmpty,
                                    
                                      cor: azulEuro),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.99,
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
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                    child: Text(
                                  "MÉDIA DE ACERTOS NO ONBOARDING POR MÊS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: isDesktop
                                      ? MainAxisAlignment.spaceEvenly
                                      : MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "FILTRAR POR ANO",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedYearDois,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedYearDois = newValue!;
                                        });
                                      },
                                      items: years.map((String year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      underline: const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: SizedBox(
                                  height: 400,
                                  child: LinearDash(
                                      selectedYear: selectedYearDois,
                                      progressoMes: mapAcertosMes,
                                    //  msgEmpty: dataByYear[selectedYearUm]!.isEmpty, //VERIFICAR ISSO AQUI
                                      cor: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.99,
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "QUANTIDADE DE PROCESSOS CRIADOS POR MÊS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: isDesktop
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "FILTRAR POR ANO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedYearTres,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYearTres = newValue!;
                                    });
                                  },
                                  items: years.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SizedBox(
                              height: 400,
                              child: BarrasDash(
                                data: getBarFilteredDataByYear(),
                                showNoDataMessage:
                                    getBarFilteredDataByYear().isEmpty,
                                yearEmpty: getBarFilteredDataByYear().isEmpty,
                                cor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                )
              :
              //mobile
              Column(
                  children: [
                    const BannerAdmin(
                      titulo: Text(
                        "DASHBOARDS",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      isIconButton: false,
                      icon: (FontAwesomeIcons.chartPie),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.70,
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "FAIXA ETÁRIA DOS NOVOS COLABORADORES POR ANO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: isDesktop
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "FILTRAR POR ANO:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedYearQuatro,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYearQuatro = newValue!;
                                    });
                                  },
                                  items: years.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              height: 200,
                              child: PieDash(
                                  idades: mapAnosIdades,
                                  selectedYear:
                                      selectedYearQuatro), // Passando o ano selecionado para o gráfico de pizza
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.70,
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "QUESTÕES CERTAS E ERRADAS POR ANO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: isDesktop
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "FILTRAR POR ANO:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedYearCinco,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYearCinco = newValue!;
                                    });
                                  },
                                  items: years.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SizedBox(
                              height: 200,
                              child: PieDashDois(
                                anosRespondidas: mapAnosRespondidas,
                                anosCertas: mapAnosCertas,
                                selectedYear: selectedYearCinco,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.99,
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "MÉDIA DE PROGRESSO NO ONBOARDING POR MÊS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: isDesktop
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "FILTRAR POR ANO:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedYearUm,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYearUm = newValue!;
                                    });
                                  },
                                  items: years.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 400,
                              child: LinearDash(
                                  selectedYear: selectedYearUm,
                                  progressoMes: mapProgressoMes,
                                 // msgEmpty: dataByYear[selectedYearUm]!.isEmpty,
                                  cor: azulEuro),
                            ),
                          ),
                        ],
                      ),
                    ),
                     const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.99,
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "MÉDIA DE ACERTOS NO ONBOARDING POR MÊS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: isDesktop
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "FILTRAR POR ANO:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedYearDois,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYearDois = newValue!;
                                    });
                                  },
                                  items: years.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 400,
                              child: LinearDash(
                                  selectedYear: selectedYearDois,
                                  progressoMes: mapAcertosMes,
                                  //msgEmpty: dataByYear[selectedYearUm]!.isEmpty,
                                  cor: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.99,
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "QUANTIDADE DE PROCESSOS CRIADOS POR MÊS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: isDesktop
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "FILTRAR POR ANO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedYearTres,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYearTres = newValue!;
                                    });
                                  },
                                  items: years.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 400,
                              child: BarrasDash(
                                data: getBarFilteredDataByYear(),
                                showNoDataMessage:
                                    getBarFilteredDataByYear().isEmpty,
                                yearEmpty: getBarFilteredDataByYear().isEmpty,
                                cor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
