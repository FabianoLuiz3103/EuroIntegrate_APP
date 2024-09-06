import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/card_graficos.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/barras_dash.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/linear_dash.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pie_dash.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/pie_dash_dois.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashsIntegracaoScreen extends StatefulWidget {
  const DashsIntegracaoScreen({super.key});

  @override
  State<DashsIntegracaoScreen> createState() => _DashsIntegracaoScreenState();
}

class _DashsIntegracaoScreenState extends State<DashsIntegracaoScreen> {
  String selectedYearUm = '2024'; // Ano padrão selecionado
  String selectedYearDois = '2024'; // Ano padrão selecionado
  String selectedYearTres = '2024'; // Ano padrão selecionado
  String selectedYearQuatro = '2024';
  String selectedYearCinco = '2024';
  final List<String> years = ['2022', '2023', '2024']; // Anos disponíveis

  // Dados simulados por ano
  final Map<String, List<FlSpot>> dataByYear = {
    '2022': [
      FlSpot(0, 5),
      FlSpot(1, 3),
      FlSpot(2, 8),
      FlSpot(3, 2),
      FlSpot(4, 5),
      FlSpot(5, 6),
      FlSpot(6, 3),
      FlSpot(7, 9),
      FlSpot(8, 4),
      FlSpot(9, 6),
    ],
    '2023': [
      FlSpot(0, 3),
      FlSpot(1, 1),
      FlSpot(2, 4),
      FlSpot(3, 3),
      FlSpot(4, 7),
      FlSpot(5, 8),
      FlSpot(6, 5),
      FlSpot(7, 18),
      FlSpot(8, 9),
      FlSpot(9, 7),
    ],
    '2024': [
      FlSpot(0, 7),
      FlSpot(1, 4),
      FlSpot(2, 6),
      FlSpot(3, 9),
      FlSpot(4, 8),
      FlSpot(5, 2),
      FlSpot(6, 10),
      FlSpot(7, 7),
      FlSpot(8, 5),
      FlSpot(9, 8),
    ],
  };

    String? getFirstMonthWithData() {
  final monthData = barDataByYearAndMonthAndDept[selectedYearBarra];
  
  if (monthData != null) {
    for (String month in months) {
      if (monthData[month]?.isNotEmpty ?? false) {
        return month;
      }
    }
  }
  return null;
}

List<String> getAvailableMonths() {
  final monthData = barDataByYearAndMonthAndDept[selectedYearBarra];
  if (monthData != null) {
    return months.where((month) => monthData[month]?.isNotEmpty ?? false).toList();
  }
  return [];
}

  // Variáveis para o Dropdown de ano e mês
  String selectedYearBarra = '2024'; // Ano padrão para o gráfico de barras
  String? selectedMonth = '';
  @override
void initState() {
  super.initState();
  selectedMonth = getFirstMonthWithData();
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

  // Dados simulados por ano e mês e departamento
  final Map<String, Map<String, Map<String, List<FlSpot>>>> barDataByYearAndMonthAndDept = {
    '2022': {
      'Jan': {
        'DEPT1': [FlSpot(0, 5)],
        'DEPT2': [FlSpot(1, 2)],
        'DEPT3': [FlSpot(2, 6)],
        'DEPT4': [FlSpot(3, 8)],
        'DEPT5': [FlSpot(4, 5)],
        'DEPT6': [FlSpot(5, 3)],
      },
    },
    '2023': {
      'Jun': {
        'DEPT1': [FlSpot(0, 6)],
        'DEPT2': [FlSpot(1, 3)],
        'DEPT3': [FlSpot(2, 7)],
        'DEPT4': [FlSpot(3, 8)],
        'DEPT5': [FlSpot(4, 6)],
        'DEPT6': [FlSpot(5, 4)],
      },
      'Jul': {
        'DEPT1': [FlSpot(0, 7)],
        'DEPT2': [FlSpot(1, 4)],
        'DEPT3': [FlSpot(2, 8)],
        'DEPT4': [FlSpot(3, 9)],
        'DEPT5': [FlSpot(4, 7)],
        'DEPT6': [FlSpot(5, 5)],
      },
    },
    '2024': {
      'Jan': {
        'DEPT1': [FlSpot(0, 8)],
        'DEPT2': [FlSpot(1, 5)],
        'DEPT3': [FlSpot(2, 9)],
        'DEPT4': [FlSpot(3, 10)],
        'DEPT5': [FlSpot(4, 8)],
        'DEPT6': [FlSpot(5, 6)],
      },
      'Fev': {
        'DEPT1': [FlSpot(0, 9)],
        'DEPT2': [FlSpot(1, 6)],
        'DEPT3': [FlSpot(2, 10)],
        'DEPT4': [FlSpot(3, 11)],
        'DEPT5': [FlSpot(4, 9)],
        'DEPT6': [FlSpot(5, 7)],
      },
    },
  };

 List<FlSpot> getBarFilteredDataDept() {
  if (selectedMonth != null) {
    final Map<String, List<FlSpot>>? monthData =
        barDataByYearAndMonthAndDept[selectedYearBarra]?[selectedMonth!];
    
    if (monthData != null && monthData.isNotEmpty) {
      bool allMonthsEmpty = monthData.entries.every((entry) => entry.value.isEmpty);

      if (allMonthsEmpty) {
        return [];
      } else {
        return monthData.entries.map((entry) {
          // Considerando que 'DEPT1', 'DEPT2', ... são representações que mapeamos para os índices 0, 1, 2, ...
          return FlSpot(
            double.parse(entry.key.replaceAll('DEPT', '')),
            entry.value.first.y,
          );
        }).toList();
      }
    }
  }
  // Retorna uma lista vazia quando não há dados para o mês selecionado
  return [];
}

bool get areAllMonthsEmpty {
  if (selectedYearBarra != null) {
    final monthData = barDataByYearAndMonthAndDept[selectedYearBarra];
    
    if (monthData != null) {
      return months.every((month) {
        final dataForMonth = monthData[month];
        return dataForMonth == null || dataForMonth.isEmpty;
      });
    }
  }
  return true; // Retorna true se não houver dados para o ano selecionado
}


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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const BannerAdmin(
                titulo: Text("DASHBOARDS",  style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),),
                isIconButton: false,
              ),
              const SizedBox(height: 30),
              const CardGraficos(
                title: "ONBOARDINGS CRIADOS",
                subtitle: "TOTAL DE PROCESSOS: XXX",
              ),
              const SizedBox(
                height: 30,
              ),
              // Filtro por ano para PieDash
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar Gráfico de Pizza por Ano:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  child: PieDash(selectedYear: selectedYearQuatro), // Passando o ano selecionado para o gráfico de pizza
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CardGraficos(
                title: "ONBOARDINGS CRIADOS",
                subtitle: "TOTAL DE PROCESSOS: XXX",
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar Gráfico de Pizza por Ano:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  child: PieDashDois(selectedYear: selectedYearCinco,),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CardGraficos(
                title: "MÉDIA PROGRESSO/MÊS",
                subtitle: "TOTAL DE PROCESSOS: XXX",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar por Ano:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    data: dataByYear[selectedYearUm]!,
                     msgEmpty: dataByYear[selectedYearUm]!.isEmpty,
                     cor: azulEuro
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),




           
              const CardGraficos(
                title: "MÉDIA PROGRESSO/MÊS",
                subtitle: "TOTAL DE PROCESSOS: XXX",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar por Ano:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    data: dataByYear[selectedYearDois]!,
                    msgEmpty: dataByYear[selectedYearDois]!.isEmpty,
                    cor: Colors.orange
                  ),
                ),
              ),
          

              const CardGraficos(
                title: "PROCESSOS POR DEPT",
                subtitle: "TOTAL DE PROCESSOS: XXX",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar Barra por Ano:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedYearBarra,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYearBarra = newValue!;
                          selectedMonth = getFirstMonthWithData();
                        });
                      },
                      items: years.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar por Mês:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String?>(
                      value: selectedMonth,
                      hint: const Text("Selecione o mês"),
                       onChanged: areAllMonthsEmpty ? null : (String? newValue) {
                        setState(() {
                          selectedMonth = newValue;
                        });
                      },
                      items: months.map((String month) {
                      final isEnabled = getAvailableMonths().contains(month);
                      return DropdownMenuItem<String?>(
                        value: isEnabled ? month : null,
                        enabled: isEnabled,
                        child: Text(month),
                      );
                    }).toList(),
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
                    data: getBarFilteredDataDept(),
                    isMonth: true,
                    showNoDataMessage: getBarFilteredDataDept().isEmpty,
                    yearEmpty: areAllMonthsEmpty,
                    cor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CardGraficos(
                title: "PROCESSOS MES",
                subtitle: "TOTAL DE PROCESSOS: XXX",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrar Barra por Ano:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    showNoDataMessage: getBarFilteredDataByYear().isEmpty,
                    yearEmpty: getBarFilteredDataByYear().isEmpty,
                    cor: Colors.green,
                  ),
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
