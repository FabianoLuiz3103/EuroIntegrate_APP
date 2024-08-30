import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Padding card({required Icon iconLeft, required Text textLeft, required double numberLeft, required Text textRight, required Icon iconRight, required double numberRight}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconLeft,
              const SizedBox(
                height: 5,
              ),
              Text('$numberLeft', style: const TextStyle(fontSize: 20)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: textLeft)
            ],
          ),
        ),
        Container(
          width: 3,
          height: 120,
          decoration: BoxDecoration(
            color: cinza,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Cor da sombra
                spreadRadius: 2, // Espalhamento da sombra
                blurRadius: 12, // Suavidade da sombra
                offset: const Offset(0, 3), // Deslocamento da sombra
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconRight,
              const SizedBox(
                height: 5,
              ),
              Text('$numberRight', style: const TextStyle(fontSize: 20)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: textRight)
            ],
          ),
        ),
      ],
    ),
  );
}
