
import 'package:eurointegrate_app/components/consts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarrasHome extends StatelessWidget {
  late final int qtdNaoIniciado;
  late final int qtdAndamento;
  late final int qtdFinalizado;
  BarrasHome({required this.qtdNaoIniciado, required this.qtdAndamento, required this.qtdFinalizado});
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                switch (value.toInt()) {
                  case 0:
                    return const Text('N.I.', style: style);
                  case 1:
                    return const Text('AND.', style: style);
                  case 2:
                    return const Text('FINA.', style: style);
                  default:
                    return const Text('');
                }
              },
            ),
          ),
           leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: qtdNaoIniciado.toDouble(), color: Colors.red)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: qtdAndamento.toDouble(), color: azulEuro)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: qtdFinalizado.toDouble(), color: Colors.green)]),
        ],
      ),
    );
  }
}
