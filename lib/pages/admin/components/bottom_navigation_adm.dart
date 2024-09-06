import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBarAdmin extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBarAdmin({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items:  <BottomNavigationBarItem>[
        bottomItem(const Icon(Icons.home), 'Home'),
         bottomItem(const Icon(FontAwesomeIcons.userPlus), 'Colaboradores'),
          bottomItem(const Icon(FontAwesomeIcons.squarePlus), 'Onboarding'),
          bottomItem(const Icon(FontAwesomeIcons.listCheck), 'Lista Onboarding'),
          bottomItem(const Icon(FontAwesomeIcons.chartPie), 'Dashboards'),
      ],
      selectedItemColor: amareloEuro,
      unselectedItemColor: cinza,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}


BottomNavigationBarItem bottomItem(Icon icon, String label){
  return BottomNavigationBarItem(
          icon: icon,
          label: label,
        );
}
