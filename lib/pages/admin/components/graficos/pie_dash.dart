import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieDash extends StatefulWidget {
  final String selectedYear;

  const PieDash({required this.selectedYear, Key? key}) : super(key: key);

  @override
  _PieDashState createState() => _PieDashState();
}

class _PieDashState extends State<PieDash> {
  int? touchedIndex;

  // Dados simulados para o gráfico de pizza por ano
  final Map<String, List<PieChartSectionData>> pieDataByYear = {
    '2024': [
      PieChartSectionData(
        color: Colors.pink,
        value: 20,
        title: '20%',
        radius: 90,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: azulEuro,
        value: 33,
        title: '33%',
        radius: 90,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.lightGreen,
        value: 33,
        title: '33%',
        radius: 90,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.lightBlue,
        value: 33,
        title: '33%',
        radius: 90,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.deepPurple,
        value: 33,
        title: '33%',
        radius: 90,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
    '2022': [
      PieChartSectionData(
        color: Colors.redAccent,
        value: 25,
        title: '25%',
        radius: 90,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
    // '2023': [
    //   PieChartSectionData(
    //     color: Colors.green,
    //     value: 50,
    //     title: '50%',
    //     radius: 90,
    //     titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    //   ),
    // ],
  };

  @override
  Widget build(BuildContext context) {
    final sections = pieDataByYear[widget.selectedYear] ?? [];
    if (sections.isEmpty) {
      return const Center(
        child: Text(
          'Sem dados para o ano selecionado',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: showingSections(sections), // Chama a função para mostrar as seções com animação
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
                    _updateTouchedIndex(pieTouchResponse!.touchedSection!.touchedSectionIndex);
                  } else if (event is FlLongPressEnd || event is FlPanEndEvent) {
                    _updateTouchedIndex(null);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
        if (touchedIndex != null) Center(child: _mostrarLegenda(touchedIndex!)),
      ],
    );
  }

  void _updateTouchedIndex(int? newIndex) {
    if (newIndex != touchedIndex) {
      setState(() {
        touchedIndex = newIndex;
      });
    }
  }

  List<PieChartSectionData> showingSections(List<PieChartSectionData> sections) {
    // Retorna as seções com o aumento de raio para a seção tocada
    return sections.asMap().map((index, section) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 120 : 90; // Aumenta o raio para 120 se a seção estiver tocada
      final updatedSection = section.copyWith(radius: radius); // Atualiza a seção com o novo raio
      return MapEntry(index, updatedSection);
    }).values.toList();
  }

  Widget _mostrarLegenda(int index) {
    switch (index) {
      case 0:
        return ItemLegenda(
          cor: Colors.pink,
          legenda: 'Maior que 18; Menor ou igual a 25'.toUpperCase(),
          pie: true,
        );
      case 1:
        return ItemLegenda(
          cor: azulEuro,
          legenda: 'Maior que 25; Menor ou igual a 30'.toUpperCase(),
          pie: true,
        );
      case 2:
        return ItemLegenda(
          cor: Colors.lightGreen,
          legenda: 'Maior que 30; Menor ou igual a 40'.toUpperCase(),
          pie: true,
        );
      case 3:
        return ItemLegenda(
          cor: Colors.lightBlue,
          legenda: 'Maior que 40; Menor ou igual a 50'.toUpperCase(),
          pie: true,
        );
      case 4:
        return ItemLegenda(
          cor: Colors.deepPurple,
          legenda: 'Maior que 50'.toUpperCase(),
          pie: true,
        );
      default:
        return const ItemLegenda(cor: Color.fromARGB(0, 255, 255, 255), legenda: "");
    }
  }
}
