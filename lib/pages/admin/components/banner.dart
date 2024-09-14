import 'package:eurointegrate_app/pages/admin/components/sinal_ativo.dart';
import 'package:eurointegrate_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BannerAdmin extends StatelessWidget {
  final Text titulo;
  final bool isIconButton;
  final IconData icon;

  const BannerAdmin({
    Key? key,
    required this.titulo,
    this.isIconButton = false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM - yyyy', 'pt_BR').format(DateTime.now());

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95, // Ajuste para a largura da tela
          height: MediaQuery.of(context).size.height * 0.24,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isIconButton)
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context); 
                        },
                      )
                    else
                     
                      IconButton(
          onPressed: () {
             Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
          },
          icon: Icon(Icons.power_settings_new),
        ),
                     
                    Row(
                      children: [
                        const Text("ATIVO"),
                        const SizedBox(width: 10),
                        BlinkingCircle(), // Certifique-se de que BlinkingCircle está implementado corretamente
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon, size: 50),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: titulo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}