import 'package:flutter/material.dart';

class CardGraficos extends StatelessWidget {
  const CardGraficos({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.altura,
  });

  final String title;
  final String subtitle;
  final double? altura;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.95,
        height: altura ?? MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: subtitle.isEmpty 
              ? MainAxisAlignment.center // Centraliza o title quando não há subtitle
              : MainAxisAlignment.start, // Alinhamento normal quando há subtitle
          children: [
            Padding(
              padding: subtitle.isEmpty 
                  ? EdgeInsets.zero  // Sem padding extra quando centralizado
                  : const EdgeInsets.only(top: 16.0),  // Adiciona espaço no topo quando há subtitle
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 20), // Espaçamento entre title e subtitle
              Center(
                child: Text(subtitle),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
