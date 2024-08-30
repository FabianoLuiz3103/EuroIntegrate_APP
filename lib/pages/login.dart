import 'package:eurointegrate_app/components/campo.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/main_screen.dart';
import 'package:eurointegrate_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  String? _mensagemErro;
  bool erro = false;
  bool obscureText = true;
  bool _carregando = false;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });
    var url = Uri.parse('$urlAPI/users/login');
    var body = {"email": _email.text, "senha": _senha.text};
    var jsonBody = jsonEncode(body);
    http.Response? response;
    try {
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );
      await Future.delayed(const Duration(seconds: 1));

      // if (response.statusCode == 200) {
      //    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      //   String token = jsonResponse["token"];
      //   print('Resposta: ${jsonResponse}');
      // } else {
      //   print('Falha ao fazer login: ${response.statusCode}');
      // }
    } catch (e) {
      print('Erro: $e');
    }

    setState(() {
      if (response!.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String token = jsonResponse["token"]["token"];
        int id = jsonResponse["idColaborador"]["idColaborador"];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    token: token,
                    id: id,
                  )),
        );
      }
      if (response.statusCode == 401) {
        _mensagemErro = '${response.body}: email ou senha inválidos';
        _carregando = false;
        erro = true;
      }
    });
  }

  void mostrarSenha() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: azulEuro,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Validando dados...",
                  )
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: azulEuro,
                    borderRadius: BorderRadius.only(
                      bottomLeft: medidaRaio, // Raio do canto inferior esquerdo
                      bottomRight: medidaRaio, // Raio do canto inferior direito
                    ),
                  ),
                  child: FractionallySizedBox(
                    widthFactor:
                        1.5, // Ajuste essa fração para aumentar ou diminuir o tamanho
                    heightFactor: 1.5,
                    child: Image.asset(
                      "images/lg_branco.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
                        child: campoForm(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            label: 'E-mail',
                            erro: erro,
                            isSenha: false)),
                    const SizedBox(height: 15.0),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
                        child: campoForm(
                            controller: _senha,
                            obscureText: obscureText,
                            label: 'Senha',
                            erro: erro,
                            mostrarSenha: mostrarSenha,
                            isSenha: true)),
                    const SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _login,
                        style: const ButtonStyle(
                          backgroundColor: botaoAzul,
                          shape: radiusBorda,
                        ),
                        child: const Text(
                          "ACESSAR",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if (_mensagemErro != null)
                      Text(
                        _mensagemErro!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
