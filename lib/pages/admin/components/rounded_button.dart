import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';

Widget btn_amarelo({required String label, Function? funcao}) {
  return SizedBox(
    width: 200,
    height: 50,
    child: ElevatedButton(
      onPressed: () async {
       funcao!();
      },
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(amareloEuro),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
    ),
  );
}

