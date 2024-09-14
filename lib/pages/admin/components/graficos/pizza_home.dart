

import 'package:eurointegrate_app/components/consts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PizzaHome extends StatefulWidget {
  final int totalProcessos;
  final int seusProcessos;

PizzaHome({required this.totalProcessos, required this.seusProcessos});
  @override
  _PizzaHomeState createState() => _PizzaHomeState();
}

class _PizzaHomeState extends State<PizzaHome> {
  int? touchedIndex;
   late int processosRestantes;
   late double porcentagemRestante;

  @override
  void initState() {
    super.initState();
    processosRestantes = widget.totalProcessos - widget.seusProcessos;
    var porc = (processosRestantes/widget.totalProcessos)*100;
    porcentagemRestante = double.parse(porc.toStringAsFixed(2));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: showingSections(),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        if (touchedIndex != null && touchedIndex != -1)
          Text(
            touchedIndex == 0 ? 'Outros processos: $processosRestantes'.toUpperCase() : 'Processos que você criou: ${widget.seusProcessos}'.toUpperCase(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: amareloEuro,
        value: processosRestantes.toDouble(),
        title: '${(porcentagemRestante).toStringAsFixed(2)}%',
        radius: touchedIndex == 0 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 18 : 16,
          fontWeight: FontWeight.bold,
          color: azulEuro,
        ),
      ),
      PieChartSectionData(
        color: azulEuro,
        value: widget.seusProcessos.toDouble(),
        title: '${(100.0 - porcentagemRestante).toStringAsFixed(2)}%',
        radius: touchedIndex == 1 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 18 : 16,
          fontWeight: FontWeight.bold,
          color: amareloEuro,
        ),
      ),
    ];
  }
}