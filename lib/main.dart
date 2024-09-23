// import 'package:eurointegrate_app/pages/login.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/pages/admin/cadastro_onboarding.dart';
import 'package:eurointegrate_app/pages/admin/dashs_integracao.dart';
import 'package:eurointegrate_app/pages/admin/home_admin.dart';
import 'package:eurointegrate_app/pages/home.dart';
import 'package:eurointegrate_app/pages/login.dart';
import 'package:eurointegrate_app/pages/perfil.dart';
import 'package:eurointegrate_app/pages/ranking_screen.dart';
import 'package:eurointegrate_app/pages/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EuroIntegrate',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: azulEuro),
        useMaterial3: false,
      ),
       localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
     Locale('pt', 'BR'), 

  ],
    home: SplashScreen()
    );
  }
}
