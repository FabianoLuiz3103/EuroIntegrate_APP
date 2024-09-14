import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieDashDois extends StatefulWidget {
  final Map<String, List<int>> anosRespondidas;
  final Map<String, List<int>> anosCertas;
  final String selectedYear;

  const PieDashDois({
    required this.anosRespondidas,
    required this.anosCertas,
    required this.selectedYear,
    Key? key,
  }) : super(key: key);

  @override
  _PieDashDoisState createState() => _PieDashDoisState();
}

class _PieDashDoisState extends State<PieDashDois> {
  int? touchedIndex;
  int erradas = 0;

  @override
  Widget build(BuildContext context) {
    final respondidas = widget.anosRespondidas[widget.selectedYear] ?? [];
    final certas = widget.anosCertas[widget.selectedYear] ?? [];

    // Calcular o total de respostas e respostas certas
    final totalRespondidas = respondidas.reduce((a, b) => a + b);
    final totalCertas = certas.reduce((a, b) => a + b);
    final totalErradas = totalRespondidas - totalCertas;
    erradas = totalErradas;

    if (totalRespondidas == 0) {
      return const Center(
        child: Text(
          'Nenhuma pergunta respondida neste ano',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }

    final sections = [
      PieChartSectionData(
        color: Colors.green.shade800,
        value: totalCertas.toDouble(),
        title: '$totalCertas',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red.shade800,
        value: totalErradas.toDouble(),
        title: '$totalErradas',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: showingSections(sections),
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
    return sections.asMap().map((index, section) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 60 : 50;
      final updatedSection = section.copyWith(radius: radius);
      return MapEntry(index, updatedSection);
    }).values.toList();
  }

  Widget _mostrarLegenda(int index) {
    if (index == 0) {
      return ItemLegenda(
        cor: Colors.green.shade800,
        legenda: 'Certas: ${(widget.anosCertas[widget.selectedYear]?.reduce((a, b) => a + b) ?? 0).toInt()}'.toUpperCase(),
        pie: true,
      );
    } else if (index == 1) {
      return ItemLegenda(
        cor: Colors.red.shade800,
        legenda: 'Erradas: $erradas'.toUpperCase(),
        pie: true,
      );
    } else {
      return const ItemLegenda(cor: Colors.transparent, legenda: "");
    }
  }
}
