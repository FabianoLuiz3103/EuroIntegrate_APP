import 'dart:convert';

import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ListagemIntegracao extends StatefulWidget {
  final String token;
  const ListagemIntegracao({super.key, required this.token});

  @override
  State<ListagemIntegracao> createState() => _ListagemIntegracaoState();
}

class _ListagemIntegracaoState extends State<ListagemIntegracao> {
  late Future<List<Integracao>>? _integracoes;
  Status? _selectedStatus;
  int? _selectedId;
  final id = 1;



  Future<List<Integracao>> _getIntegracoes() async{
     await Future.delayed(const Duration(seconds: 3));
    var url = Uri.parse('$urlAPI/rh/listar-integracoes');
    String tkn = widget.token;

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $tkn",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );
      if (response.statusCode == 200) {
        return parseIntegracao(utf8.decode(response.bodyBytes));
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return [];
    }

  }


  @override
  void initState() {
    super.initState();
    _integracoes = _getIntegracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BannerAdmin(
            titulo: Text(
              "LISTAGEM",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            icon: (FontAwesomeIcons.listCheck),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<int?>(
                items: [
                   const DropdownMenuItem(
                    value: null,
                    child: Text("Geral")),
                     DropdownMenuItem(
                      value: id,
                      child: const Text("CRIADOS POR VOCÊ"))
                ],
                 onChanged: (int? clicado){
                  setState(() {
                    _selectedId = clicado;
                  });
                 }),



              DropdownButton<Status?>(
                value: _selectedStatus,
                items: [
                 const DropdownMenuItem(
                    value: null,
                    child: Text('Todos'),
                  ),
                  ...Status.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name),
                    );
                  }).toList(),
                ],
                onChanged: (Status? newStatus) {
                  setState(() {
                    _selectedStatus = newStatus;
                  });
                },
              ),
            ],
          ),
          FutureBuilder<List<Integracao>>(
            future: _integracoes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      child: progressSkin(20),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Erro ao carregar integrações');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Nenhuma integração encontrada');
              }

              List<Integracao> filteredIntegracoes = snapshot.data!
    .where((integracao) => 
        (_selectedStatus == null || integracao.status == _selectedStatus) &&
        (_selectedId == null || integracao.rh.id == _selectedId))
    .toList();

     if (filteredIntegracoes.isEmpty) {
      return Expanded(
        child: Center(
            child: Container(
              color: Colors.red,
              child: const Text(
                'Nenhuma integração encontrada com os filtros aplicados.',
                style: TextStyle(fontSize: 16, color: Colors.white,),
              ),
            ),
        ),
      );
    }


              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: filteredIntegracoes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          margin: const EdgeInsets.all(3),
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cinza,
                              child: Text('#${filteredIntegracoes[index].id}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                            ),
                            title: Column(
                              children: [
                                Container(
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: exibirStatus(integracao: filteredIntegracoes[index],),
                                  )),
                                  
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(child: Text(filteredIntegracoes[index].departamento.nome, style: const TextStyle(fontSize: 12, color: Colors.black54),),),
                                ),
                                
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Inicio: ${_formatData(filteredIntegracoes[index].dataInicio)}   -  ${_formatTimeOfDay(filteredIntegracoes[index].horaInicio)}',
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(context: context, builder: (contex){
                                  return IntegracaoDetails(integracao: filteredIntegracoes[index]);
                                });
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String _formatData(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String _formatHora(DateTime hora) {
  return DateFormat('HH:mm').format(hora);
}


class exibirStatus extends StatelessWidget {
  const exibirStatus({
    super.key,
    required this.integracao
  });

  final Integracao integracao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: integracao.status.cor, // Cor de fundo
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        integracao.status.name,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}


class IntegracaoDetails extends StatelessWidget {
  final Integracao integracao;
  const IntegracaoDetails({super.key, required this.integracao});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
  title: Column(
    children: [
      SizedBox(
        width: 150,
        child: exibirStatus(integracao: integracao),
      ),
      _buildDivider(),
      _buildTitle("DEPARTAMENTO"),
      _buildDivider(),
      _buildText(integracao.departamento.nome),
      _buildDivider(),
      _buildTitle("INÍCIO"),
      _buildDivider(),
      _buildRow(_formatData(integracao.dataInicio), _formatTimeOfDay(integracao.horaInicio)),
      _buildDivider(),
      _buildTitle("FIM"),
      _buildDivider(),
      _buildRow(_formatData(integracao.dataFim), _formatTimeOfDay(integracao.horaFim)),
      _buildDivider(),
      _buildTitle("QUANTIDADE DE COLABORADORES"),
      _buildDivider(),
      _buildText(integracao.qtdColaboradores.toString()),
      _buildDivider(),
      _buildTitle("MÉDIA DE PROGRESSO"),
      _buildDivider(),
      _buildConditionalText(
        condition: integracao.status.name == 'FINALIZADO',
        trueText: integracao.mediaProgresso.toString(),
        falseText: "DISPONÍVEL QUANDO STATUS FOR FINALIZADO",
      ),
      _buildDivider(),
      _buildTitle("QUANTIDADE DE ACERTOS"),
      _buildDivider(),
      _buildConditionalText(
        condition: integracao.status.name == 'FINALIZADO',
        trueText: integracao.mediaAcertos.toString(),
        falseText: "DISPONÍVEL QUANDO STATUS FOR FINALIZADO",
      ),
      _buildDivider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ElevatedButton(onPressed: (){
            // Navigator.push(context,
            //  MaterialPageRoute(
            //   builder: (context) => DashsIntegracaoScreen()
            //  ),
            //  );
          }, style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(azulEuro)), 
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.auto_graph),
            SizedBox(width: 10,),
            Text("VER GRÁFICOS")
          ],),),
        ),
      ),
    ],
  ),
);


  }
}

// Funções Auxiliares

Widget _buildDivider() => Divider(color: cinza);

Widget _buildTitle(String text) => Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );

Widget _buildRow(String leftText, String rightText) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(leftText, style: const TextStyle(fontSize: 14)),
        Text(rightText, style: const TextStyle(fontSize: 14)),
      ],
    );

Widget _buildText(String text) => Text(
      text,
      style: const TextStyle(fontSize: 14),
    );

Widget _buildConditionalText({
  required bool condition,
  required String trueText,
  required String falseText,
}) =>
    Text(
      condition ? trueText : falseText,
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );


class Departamento {
  int id;
  String nome;

  Departamento({required this.id, required this.nome});

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nome: json['nome'] ?? '',
    );
  }

}

class Rh {
  int id;
  //String email;

  Rh({required this.id});

  factory Rh.fromJson(Map<String, dynamic> json) {
    return Rh(
      id: json['id'],
     // email: json['cpf'],
    );
  }

}



class Integracao {
  int? id;
  DateTime dataInicio;
  TimeOfDay horaInicio;
  DateTime dataFim;
  TimeOfDay horaFim;
  Status status;
  int? qtdColaboradores;
  Departamento departamento;
  double mediaProgresso;
  double mediaAcertos;
  Rh rh;

  Integracao(
      {this.id,
      required this.dataInicio,
      required this.horaInicio,
      required this.dataFim,
      required this.horaFim,
      required this.status,
      this.qtdColaboradores,
      required this.departamento,
      required this.mediaAcertos,
      required this.mediaProgresso,
      required this.rh});

  factory Integracao.fromJson(Map<String, dynamic> json) {
    return Integracao(
        id: json['id'],
        dataInicio: DateFormat('yyyy-MM-dd').parse(json['dataInicio']),
        horaInicio: _parseTimeOfDay(json['horaInicio']),
        dataFim: DateFormat('yyyy-MM-dd').parse(json['dataFim']),
        horaFim: _parseTimeOfDay(json['horaFim']),
          status: StatusExtension.fromString(json['status']),
        qtdColaboradores: json['qtdColaboradores'],
        departamento: Departamento.fromJson(json['departamento']),
        mediaAcertos: json['mediaAcertos'],
        mediaProgresso: json['mediaProgresso'],
        rh: Rh.fromJson(json['rh'])

        );
  }

}

extension StatusExtension on Status {
  static Status fromString(String status) {
    return Status.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => throw Exception('Status not found'),
    );
  }
}

enum Status{
  ANDAMENTO,
  FINALIZADO,
  NAO_INICIADO
}

extension StatusColor on Status {
  Color get cor {
    switch (this) {
      case Status.ANDAMENTO:
        return azulEuro; // Cor para "Em Andamento"
      case Status.FINALIZADO:
        return Colors.green;  // Cor para "Concluído"
      case Status.NAO_INICIADO:
        return Colors.red;   // Cor para "Não Iniciado"
      default:
        return Colors.black;  // Cor padrão
    }
  }
}


String _formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final formattedTime = DateFormat('HH:mm')
      .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  return formattedTime;
}

TimeOfDay _parseTimeOfDay(String time) {
  final parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

List<Integracao> parseIntegracao(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Integracao>((json) => Integracao.fromJson(json))
      .toList();
}
