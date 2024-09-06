import 'dart:ui';

import 'package:flutter/material.dart';

class ItemLegenda extends StatelessWidget {
  const ItemLegenda({
    super.key,
    required this.cor,
    required this.legenda,
    this.pie = false,
  });

  final Color cor;
  final String legenda;
  final bool pie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: pie ? Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Text(
            legenda,
            style: TextStyle(color: cor, fontWeight: FontWeight.w600),
          )
        ],
      ) : Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: cor,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            legenda,
            style: TextStyle(color: cor, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}



