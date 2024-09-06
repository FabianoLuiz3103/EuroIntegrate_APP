import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/dashs_integracao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListagemIntegracao extends StatefulWidget {
  const ListagemIntegracao({super.key});

  @override
  State<ListagemIntegracao> createState() => _ListagemIntegracaoState();
}

class _ListagemIntegracaoState extends State<ListagemIntegracao> {
  late Future<List<Integracao>>? _integracoes;
  Status? _selectedStatus; // Pode ser null para mostrar todos os itens

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
              "Listagem",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
       
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
                  .where((integracao) => _selectedStatus == null || integracao.status == _selectedStatus)
                  .toList();

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
                                  child: Center(child: Text(filteredIntegracoes[index].departamento, style: const TextStyle(fontSize: 12, color: Colors.black54),),),
                                ),
                                
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Inicio: ${_formatData(filteredIntegracoes[index].dataInicio)}   -  ${_formatHora(filteredIntegracoes[index].horaInicio)}',
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
      _buildText(integracao.departamento),
      _buildDivider(),
      _buildTitle("INÍCIO"),
      _buildDivider(),
      _buildRow(_formatData(integracao.dataInicio), _formatHora(integracao.horaInicio)),
      _buildDivider(),
      _buildTitle("FIM"),
      _buildDivider(),
      _buildRow(_formatData(integracao.dataFim), _formatHora(integracao.horaFim)),
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


Future<List<Integracao>> _getIntegracoes() async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    Integracao(
      id:1,
      dataInicio: DateTime(2024, 9, 2),
      horaInicio: DateTime(2024, 9, 2, 13, 19),
      dataFim: DateTime(2024, 9, 6),
      horaFim: DateTime(2024, 9, 2, 17, 19),
      status: Status.NAO_INICIADO,
      departamento: 'MARKETING',
      qtdColaboradores: 32,
      mediaProgresso: 15.64,
      mediaAcertos: 20.29,
    ),
    Integracao(
      id:2,
      dataInicio: DateTime(2024, 9, 4),
      horaInicio: DateTime(2024, 9, 4, 10, 9),
      dataFim: DateTime(2024, 9, 6),
      horaFim: DateTime(2024, 9, 4, 14, 9),
      status: Status.NAO_INICIADO,
      departamento: 'MARKETING',
      qtdColaboradores: 33,
      mediaProgresso: 83.52,
      mediaAcertos: 92.33,
    ),
    Integracao(
      id:3,
      dataInicio: DateTime(2024, 8, 26),
      horaInicio: DateTime(2024, 8, 27, 5, 44),
      dataFim: DateTime(2024, 8, 31),
      horaFim: DateTime(2024, 8, 27, 6, 44),
      status: Status.NAO_INICIADO,
      departamento: 'RECURSOS HUMANOS (RH)',
      qtdColaboradores: 8,
      mediaProgresso: 64.05,
      mediaAcertos: 34.36,
    ),
    Integracao(
      id:4,
      dataInicio: DateTime(2024, 8, 7),
      horaInicio: DateTime(2024, 8, 7, 18, 5),
      dataFim: DateTime(2024, 8, 12),
      horaFim: DateTime(2024, 8, 7, 19, 5),
      status: Status.ANDAMENTO,
      departamento: 'RECURSOS HUMANOS (RH)',
      qtdColaboradores: 40,
      mediaProgresso: 45.8,
      mediaAcertos: 16.87,
    ),
    Integracao(
      id:5,
      dataInicio: DateTime(2024, 8, 18),
      horaInicio: DateTime(2024, 8, 18, 10, 49),
      dataFim: DateTime(2024, 8, 23),
      horaFim: DateTime(2024, 8, 18, 11, 49),
      status: Status.ANDAMENTO,
      departamento: 'TECNOLOGIA DA INFORMAÇÃO (TI)',
      qtdColaboradores: 7,
      mediaProgresso: 63.54,
      mediaAcertos: 35.74,
    ),
    Integracao(
      id:6,
      dataInicio: DateTime(2024, 8, 23),
      horaInicio: DateTime(2024, 8, 24, 3, 3),
      dataFim: DateTime(2024, 8, 24),
      horaFim: DateTime(2024, 8, 24, 5, 3),
      status: Status.NAO_INICIADO,
      departamento: 'RISCOS',
      qtdColaboradores: 50,
      mediaProgresso: 80.42,
      mediaAcertos: 3.9,
    ),
    Integracao(
      id:7,
      dataInicio: DateTime(2024, 9, 2),
      horaInicio: DateTime(2024, 9, 2, 17, 1),
      dataFim: DateTime(2024, 9, 7),
      horaFim: DateTime(2024, 9, 2, 20, 1),
      status: Status.ANDAMENTO,
      departamento: 'TECNOLOGIA DA INFORMAÇÃO (TI)',
      qtdColaboradores: 44,
      mediaProgresso: 91.01,
      mediaAcertos: 95.62,
    ),
    Integracao(
      id: 8,
      dataInicio: DateTime(2024, 8, 10),
      horaInicio: DateTime(2024, 8, 10, 22, 6),
      dataFim: DateTime(2024, 8, 15),
      horaFim: DateTime(2024, 8, 10, 23, 6),
      status: Status.NAO_INICIADO,
      departamento: 'MARKETING',
      qtdColaboradores: 10,
      mediaProgresso: 85.73,
      mediaAcertos: 77.55,
    ),
    Integracao(
      id:9,
      dataInicio: DateTime(2024, 8, 30),
      horaInicio: DateTime(2024, 8, 31, 0, 45),
      dataFim: DateTime(2024, 8, 31),
      horaFim: DateTime(2024, 8, 31, 4, 45),
      status: Status.FINALIZADO,
      departamento: 'FINANCEIRO',
      qtdColaboradores: 5,
      mediaProgresso: 86.29,
      mediaAcertos: 22.1,
    ),
    Integracao(
      id: 10,
      dataInicio: DateTime(2024, 8, 30),
      horaInicio: DateTime(2024, 8, 30, 6, 37),
      dataFim: DateTime(2024, 8, 31),
      horaFim: DateTime(2024, 8, 30, 8, 37),
      status: Status.FINALIZADO,
      departamento: 'TECNOLOGIA DA INFORMAÇÃO (TI)',
      qtdColaboradores: 45,
      mediaProgresso: 6.41,
      mediaAcertos: 2.26,
    ),
  ];
}


class Integracao {
  int id;
  DateTime dataInicio;
  DateTime horaInicio;
  DateTime dataFim;
  DateTime horaFim;
  Status status;
  String departamento;
  int qtdColaboradores;
  double mediaProgresso;
  double mediaAcertos;

  Integracao(
      {required this.id,
        required this.dataInicio,
      required this.horaInicio,
      required this.dataFim,
      required this.horaFim,
      required this.status,
      required this.departamento,
      required this.qtdColaboradores,
      required this.mediaProgresso,
      required this.mediaAcertos});
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
