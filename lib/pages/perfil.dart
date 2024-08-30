import 'dart:convert';

import 'package:avatar_maker/avatar_maker.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/pages/editar_avatar.dart';
import 'package:eurointegrate_app/pages/editar_telefone.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Perfil extends StatefulWidget {
  final String token;
  final int id;
  const Perfil({super.key, required this.token, required this.id});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Map? userData;

  Future<void> _fetchData() async {
    var url = Uri.parse('$urlAPI/colaboradores/perfil/${widget.id}');
    String token = widget.token;

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Erro na requisição: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações pessoais'),
        backgroundColor: azulEuro,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        AvatarMakerAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 40,
                        ),
                        const SizedBox(width: 16), // Espaçamento entre avatar e texto
                        Expanded(
                          child: Text(
                            '${userData?['primeiroNome']} ${userData?['sobrenome']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditarAvatar(token: widget.token, pontos: userData!['pontuacao'],id: widget.id)),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Informação pessoal 1
                CardPerfil(icon: Icons.person_outline, title: "Nome e sobrenome", subtitle: "${userData!['primeiroNome']} ${userData!['sobrenome']}",),
                const Divider(),
                // Informação pessoal 2
                CardPerfil(icon: Icons.credit_card, title: "Documento de identidade", subtitle: "${userData!['cpf']}"),
              
                const Divider(),
                // Informação pessoal 3
                CardPerfil(icon: Icons.cake_outlined, title: "Data de nascimento", subtitle: "${formatarData(userData!['dataNascimento'])}"),
        
                const Divider(),
                // Informação pessoal 4
                
                Row(
                  children: [
                    Icon(Icons.phone_android),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Telefone'),
                          Text('${userData?['telefone']}'),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditarTelefone(telefone: userData!['telefone'] ?? '')),
                        );
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
                const Divider(),
                // Informação pessoal 5

                CardPerfil(icon: Icons.mail_outline, title: "E-mail institucional", subtitle: "${userData!['email']}"),
               
                const Divider(),
                // Informação pessoal 6
                CardPerfil(icon: Icons.calendar_month_outlined, title: "Data de admissão", subtitle: "${formatarData(userData!['dataAdmissao'])}"),
              
                const Divider(),
                // Informação pessoal 7
                CardPerfil(icon: Icons.location_on_outlined, title: "Departamento", subtitle: "${userData!['departamento']['nome']}"),
                const Divider(),
                // Informação pessoal 8
                CardPerfil(icon: Icons.badge_outlined, title: "Matrícula", subtitle: "${userData?['matricula']}"),
              
                const Divider(),
                CardPerfil(icon: Icons.power_settings_new, title: "Sair", subtitle: ""),
              ],
            ),
    );
  }
}

class CardPerfil extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const CardPerfil({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 16), // Espaçamento entre ícone e texto
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(subtitle),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.lock_outlined),
        ),
      ],
    );
  }
}
