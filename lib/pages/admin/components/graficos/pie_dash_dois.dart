import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieDashDois extends StatefulWidget {
  final String selectedYear; // Adiciona o parâmetro para o ano selecionado

  const PieDashDois({required this.selectedYear, Key? key}) : super(key: key);

  @override
  _PieDashDoisState createState() => _PieDashDoisState();
}

class _PieDashDoisState extends State<PieDashDois> {
  int? touchedIndex;

  // Dados simulados para o gráfico de pizza por ano
  final Map<String, List<PieChartSectionData>> pieDataByYear = {
    '2022': [
      PieChartSectionData(
        color: Colors.green.shade800,
        value: 40,
        title: '40%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red.shade800,
        value: 60,
        title: '60%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
    '2023': [
      PieChartSectionData(
        color: Colors.green.shade800,
        value: 50,
        title: '50%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red.shade800,
        value: 50,
        title: '50%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
    '2024': [
      PieChartSectionData(
        color: Colors.green.shade800,
        value: 70,
        title: '70%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red.shade800,
        value: 30,
        title: '30%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
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
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: showingSections(sections), // Filtra as seções com base no ano
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
      final double radius = isTouched ? 60 : 50; // Aumenta o raio para 60 se a seção estiver tocada
      final updatedSection = section.copyWith(radius: radius); // Atualiza a seção com o novo raio
      return MapEntry(index, updatedSection);
    }).values.toList();
  }

  Widget _mostrarLegenda(int index) {
    switch (index) {
      case 0:
        return ItemLegenda(
          cor: Colors.green.shade800,
          legenda: 'Certas: ${(pieDataByYear[widget.selectedYear]?[0].value ?? 0).toInt()}'.toUpperCase(),
          pie: true,
        );
      case 1:
        return ItemLegenda(
          cor: Colors.red.shade800,
          legenda: 'Erradas: ${(pieDataByYear[widget.selectedYear]?[1].value ?? 0).toInt()}'.toUpperCase(),
          pie: true,
        );
      default:
        return const ItemLegenda(cor: Color.fromARGB(0, 255, 255, 255), legenda: "");
    }
  }
}
