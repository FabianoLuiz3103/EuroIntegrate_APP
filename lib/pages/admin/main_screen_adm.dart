import 'package:eurointegrate_app/pages/admin/cadastro_colaboradores.dart';
import 'package:eurointegrate_app/pages/admin/cadastro_onboarding.dart';
import 'package:eurointegrate_app/pages/admin/components/bottom_navigation_adm.dart';
import 'package:eurointegrate_app/pages/admin/dashs_integracao.dart';
import 'package:eurointegrate_app/pages/admin/home_admin.dart';
import 'package:eurointegrate_app/pages/admin/listagem_integracao.dart';
import 'package:flutter/material.dart';

class MainScreenAdmin extends StatefulWidget {
 
  const MainScreenAdmin({Key? key,}) : super(key: key);

  @override
  _MainScreenAdminState createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeAdminScreen(),
      CadastroColaboradoresScreen(),
      CadastroOnboardingScreen(),
      ListagemIntegracao(),
      DashsIntegracaoScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
