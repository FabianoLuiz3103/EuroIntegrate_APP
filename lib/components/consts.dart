import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
const medidaRaio = Radius.circular(25.0);
const raio =  BorderRadius.all(medidaRaio);
const azulEuro = Color.fromARGB(255, 0, 72, 142);
const amareloEuro = Color.fromARGB(255, 255, 242, 0);
const cinza = Color(0xFFD9D9D9);
const WidgetStateProperty<Color> botaoAzul = WidgetStatePropertyAll(azulEuro);
const WidgetStateProperty<OutlinedBorder> radiusBorda = WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: raio),);
final phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

String formatarData(String data) {
  DateTime dateTime = DateTime.parse(data);
  return DateFormat('dd/MM/yy').format(dateTime);
}
const String urlAPI = "https://fine-worlds-arrive.loca.lt";
