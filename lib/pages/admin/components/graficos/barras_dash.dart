import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarrasDash extends StatelessWidget {
  final List<FlSpot> data;
  final bool isMonth;
  final bool showNoDataMessage;
  final bool yearEmpty;
  final Color cor;

  BarrasDash({required this.data, this.isMonth = false, this.showNoDataMessage = false, this.yearEmpty = false, required this.cor});

  @override
  Widget build(BuildContext context) {
    return data.isEmpty && showNoDataMessage
        ? Center(
            child: yearEmpty ? Text(
              'Sem dados para o ano escolhido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ) :  Text(
              'Sem dados para o mês escolhido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ) :
    BarChart(
      BarChartData(
         // Define o mínimo para o eixo X
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1, // Garante que todos os rótulos sejam mostrados
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                // Lista completa dos rótulos para os 12 meses
                final titles = isMonth  ? ['','TI', 'FINAN', 'MKT', 'JUR', 'RH', 'RIS']: [
                  'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 
                  'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'
                ];

                // Verifica se o valor está dentro do intervalo de 0 a 11
                if (value.toInt() >= 0 && value.toInt() < titles.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildRotatedTitle(titles[value.toInt()], style),
                  );
                } else {
                  return const SizedBox.shrink(); // Evita erro de índice fora do intervalo
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
        // Define os dados das barras com base nos valores do FlSpot
        barGroups: data
            .map((spot) => BarChartGroupData(
                  x: spot.x.toInt(), // Certifique-se que `x` vai de 0 a 11
                  barRods: [
                    BarChartRodData(
                      toY: spot.y,
                      color: cor,
                      width: 15,
                    ),
                  ],
                ))
            .toList(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toString(),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Função para aplicar rotação aos rótulos do eixo X
  Widget _buildRotatedTitle(String title, TextStyle style) {
    return Transform.rotate(
      angle: -0.5, // Ajuste o ângulo conforme necessário (radianos)
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }
}
