import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';


class CampoNovo extends StatelessWidget {
  const CampoNovo({
    super.key,
    required this.nomeController,
    required this.label,
  });

  final TextEditingController nomeController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Color(0x80424242)),
        ),
        TextField(
          controller: nomeController,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:Color(0x80424242)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: azulEuro),
            ),
          ),
        ),
      ],
    ),
      );
  }
}
