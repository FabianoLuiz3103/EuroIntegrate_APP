import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


Widget campoForm({
  required TextEditingController controller,
  TextInputType? keyboardType,
  bool? obscureText,
  required String label,
  required bool erro,
  void Function()? mostrarSenha,
  required bool isSenha,
  required FormFieldValidator<String> validacao,
  bool? isCpf
}) {
  final borderSide = BorderSide(
    color: erro ? Colors.red : Colors.grey, // Cor padrão ou cor de erro
  );

  final focusedBorderSide = BorderSide(
    color: azulEuro, // Cor quando o campo está em foco e sem erros
  );

  return ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: 400, // Defina o valor máximo desejado para a largura
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: raio, 
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: focusedBorderSide,
          borderRadius: raio,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, 
          ),
          borderRadius: raio,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Cor para erro em foco
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
      validator: validacao,
      inputFormatters: isCpf! ? [
        MaskedInputFormatter('###.###.###-##'),
      ] : [],
    ),
  );
}

