import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.95,
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
        
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Olá, Marcos!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),)
                            ],
                          ),
                ),
              ),
            ),
            SizedBox(height: 12,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Padding(
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: Text(
                    "Perfil - Administrador",
                    style: TextStyle(color: cinza, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cardHomeAdmin(icon: Icons.headphones, titulo: "CARD - 1", ontap: (){print("CARD 1 CLICADO!");}),
                      cardHomeAdmin(icon: Icons.save, titulo: "CARD - 2", ontap: (){print("CARD 2 CLICADO!");})
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cardHomeAdmin(icon: Icons.abc, titulo: "CARD - 3", ontap: (){print("CARD 3 CLICADO!");}),
                      cardHomeAdmin(
                          icon: Icons.sports_volleyball_rounded, titulo: "CARD - 4", ontap: (){print("CARD 4 CLICADO!");})
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardHomeAdmin({required IconData icon, required String titulo, required VoidCallback ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black, width: 2.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
            ),
            Text(titulo)
          ],
        ),
      ),
    );
  }
}
