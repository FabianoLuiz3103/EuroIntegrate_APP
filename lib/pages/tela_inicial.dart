import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      setState(() {
        isConnected = true;
      });
      _navigateToLogin();
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  void _navigateToLogin() {
    Timer(const Duration(seconds: 3), () {
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>  const Login()
       ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulEuro,
      body: Center(
        child: isConnected
            ? Column(
              children: [
                Image.asset(
                        "images/lg_branco.png",
                        fit: BoxFit.contain,
                      ),
                progressSkinIni(30)
              ],
            ) // Loading spinner
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  Text('Sem conexão com a internet', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }
}
