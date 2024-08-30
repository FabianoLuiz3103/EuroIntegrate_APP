// import 'package:eurointegrate_app/pages/login.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/main_screen.dart';
import 'package:eurointegrate_app/pages/conquistas_screen.dart';
import 'package:eurointegrate_app/pages/guia.dart';
import 'package:eurointegrate_app/pages/login.dart';
import 'package:eurointegrate_app/pages/video_screen.dart';
import 'package:flutter/material.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: azulEuro),
        useMaterial3: false,
      ),
      home: const Login(),
    );
  }
}

