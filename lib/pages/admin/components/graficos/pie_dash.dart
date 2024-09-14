import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/pages/admin/components/graficos/item_legenda.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieDash extends StatefulWidget {
  final Map<String, List<int>> idades;
  final String selectedYear;

  const PieDash({required this.idades, required this.selectedYear, Key? key})
      : super(key: key);

  @override
  _PieDashState createState() => _PieDashState();
}

class _PieDashState extends State<PieDash> {
  int? touchedIndex;

  // Definir faixas etárias com cores fixas
  final List<Map<String, dynamic>> faixasEtarias = [
    {'faixa': '18-25', 'min': 18, 'max': 25, 'color': Colors.pink},
    {'faixa': '26-30', 'min': 26, 'max': 30, 'color': azulEuro},
    {'faixa': '31-40', 'min': 31, 'max': 40, 'color': Colors.lightGreen},
    {'faixa': '41-50', 'min': 41, 'max': 50, 'color': Colors.lightBlue},
    {'faixa': '51+', 'min': 51, 'max': null, 'color': Colors.deepPurple},
  ];

  // Mapeia cores para as faixas etárias
  Map<Color, String> legendaPorCor = {};
  List<PieChartSectionData> sections = [];

  @override
  Widget build(BuildContext context) {
    // Obter idades para o ano selecionado
    final idadesAno = widget.idades[widget.selectedYear] ?? [];

    // Contar quantas pessoas estão em cada faixa etária
    sections.clear();
    legendaPorCor.clear(); // Limpar o mapa de legendas

    for (var faixa in faixasEtarias) {
      final int count = idadesAno
          .where((idade) =>
              idade >= faixa['min'] && (faixa['max'] == null || idade <= faixa['max']))
          .length;

      // Apenas adiciona faixas que têm pessoas
      if (count > 0) {
        final Color color = faixa['color'];
        legendaPorCor[color] = faixa['faixa']; // Mapeia cor para faixa etária

        sections.add(
          PieChartSectionData(
            color: color,
            value: count.toDouble(),
            title: '${count}', // Exibe a quantidade
            radius: touchedIndex != null && touchedIndex == sections.length ? 110 : 90, // Aumenta o raio ao clicar
            titleStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }
    }

    if (sections.isEmpty) {
      return const Center(
        child: Text(
          'Sem dados para o ano selecionado',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
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
              centerSpaceRadius: 2, // Pequeno espaço no centro
              sections: sections,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (pieTouchResponse != null &&
                      pieTouchResponse.touchedSection != null) {
                    _updateTouchedIndex(
                        pieTouchResponse.touchedSection!.touchedSectionIndex);
                  } else {
                    _updateTouchedIndex(null);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
        if (touchedIndex != null && touchedIndex! >= 0 && touchedIndex! < sections.length)
          Center(child: _mostrarLegenda(touchedIndex!, sections)),
      ],
    );
  }

  void _updateTouchedIndex(int? newIndex) {
    setState(() {
      touchedIndex = newIndex;
    });
  }

  // Ajustar legenda com base na cor
  Widget _mostrarLegenda(int index, List<PieChartSectionData> sections) {
    final Color sectionColor = sections[index].color;
    final String faixaEtaria = legendaPorCor[sectionColor] ?? '';

    return ItemLegenda(
      cor: sectionColor,
      legenda: 'Faixa etária: $faixaEtaria'.toUpperCase(),
      pie: true,
    );
  }
}
