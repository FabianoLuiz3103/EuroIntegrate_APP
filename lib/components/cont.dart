import 'package:flutter/material.dart';

Container container({required Widget card, required double largura, required double altura}) {
  return Container(
    width: largura,
    height: altura,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // Cor da sombra
          spreadRadius: 5, // Espalhamento da sombra
          blurRadius: 10, // Suavidade da sombra
          offset: const Offset(0, 3), // Deslocamento da sombra
        ),
      ],
    ),
    child: card,
  );
}
