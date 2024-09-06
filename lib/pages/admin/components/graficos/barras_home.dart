
import 'package:eurointegrate_app/components/consts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarrasHome extends StatelessWidget {
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
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        barGroups: [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 20, color: Colors.red)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 10, color: azulEuro)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 34, color: Colors.green)]),
        ],
      ),
    );
  }
}
