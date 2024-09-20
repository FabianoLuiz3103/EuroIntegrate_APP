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
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
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
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desktopWidthThreshold = 800.0;
    final isDesktop = screenWidth > desktopWidthThreshold;
    return Scaffold(
      backgroundColor: azulEuro,
      body: isDesktop
          ? Center(
              child: isConnected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment:
                              Alignment.center, 
                          children: [
                            Positioned(
                              child:   Image.asset(
                              "images/lg_branco.png",
                              fit: BoxFit
                                  .contain, 
                              height: 350.0, 
                              width: 350.0, 
                            ),),
                          
                            const Positioned(
                              top:250, 
                              left: 20, 
                              child: Text(
                                "O Caminho para uma Integração Eficiente.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        progressSkinIni(30)
                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 100, color: Colors.white),
                        SizedBox(height: 20),
                        Text('Sem conexão com a internet',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
            )
          : Center(
              child: isConnected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment:
                              Alignment.center, 
                          children: [
                            Positioned(
                              child:   Image.asset(
                              "images/lg_branco.png",
                              fit: BoxFit
                                  .contain, 
                              
                            ),),
                          
                            const Positioned(
                              top:250, 
                             // left: 20, 
                              child: Text(
                                "O Caminho para uma Integração Eficiente.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        progressSkinIni(30)
                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 100, color: Colors.white),
                        SizedBox(height: 20),
                        Text('Sem conexão com a internet',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
            ),
    );
  }
}
