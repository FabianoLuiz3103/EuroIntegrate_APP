import 'package:eurointegrate_app/components/consts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LinearDash extends StatelessWidget {
  final List<String> xLabels = [
    'ONB-1', 'ONB-2', 'ONB-3', 'ONB-4', 'ONB-5', 
    'ONB-6', 'ONB-7', 'ONB-8', 'ONB-9', 'ONB-10'
  ];

  final List<FlSpot> data; 
  final bool msgEmpty;
  final Color cor;

  LinearDash({required this.data, this.msgEmpty = false, required this.cor});

  @override
  Widget build(BuildContext context) {
    return msgEmpty ? const Center(child: Text(
          'Sem dados para o ano selecionado',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),) : Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: azulEuro.withOpacity(0.2),
                strokeWidth: 0.5,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: azulEuro.withOpacity(0.2),
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < xLabels.length) {
                    return Transform.rotate(
                      angle: -0.5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          xLabels[value.toInt()],
                          style: const TextStyle(fontSize: 10, color: azulEuro),
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: azulEuro),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          minX: 0,
          maxX: xLabels.length - 1,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: cor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    color: amareloEuro,
                    strokeWidth: 1,
                    radius: 4,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: cor.withOpacity(0.2),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                    touchedSpot.y.toString(),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
