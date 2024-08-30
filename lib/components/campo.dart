import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';

Widget campoForm(
    {required TextEditingController controller,
    TextInputType? keyboardType,
    bool? obscureText,
    required String label,
    required bool erro,
    void Function()? mostrarSenha,
    required bool isSenha}) {

      
  return ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: 400, // Defina o valor máximo desejado para a largura
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: erro
                  ? Colors.red
                  : Colors.grey, // Cor padrão quando não há erro
            ),
            borderRadius: raio,
            ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: erro ? Colors.red : azulEuro, // Cor quando o campo está em foco
            ),
            borderRadius: raio,
            ),
        suffixIcon: isSenha
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: mostrarSenha,
              )
            : null,
      ),
    ),
  );
}
