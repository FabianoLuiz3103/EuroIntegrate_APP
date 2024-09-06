import 'package:eurointegrate_app/components/consts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class pizzaHome extends StatefulWidget {
  @override
  _pizzaHomeState createState() => _pizzaHomeState();
}

class _pizzaHomeState extends State<pizzaHome> {
  int? touchedIndex;

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
            touchedIndex == 0 ? 'Outros processos' : 'Processos que você criou',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: amareloEuro,
        value: 20,
        title: '20%',
        radius: touchedIndex == 0 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 18 : 16,
          fontWeight: FontWeight.bold,
          color: azulEuro,
        ),
      ),
      PieChartSectionData(
        color: azulEuro,
        value: 33,
        title: '33%',
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