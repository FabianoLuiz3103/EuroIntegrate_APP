import 'dart:convert';

import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CadastroOnboardingScreen extends StatefulWidget {
  final String token;
  final int id;
  const CadastroOnboardingScreen({super.key, required this.token, required this.id});

  @override
  State<CadastroOnboardingScreen> createState() =>
      _CadastroOnboardingScreenState();
}

class _CadastroOnboardingScreenState extends State<CadastroOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dataInicio = TextEditingController();
  final TextEditingController _horaInicio = TextEditingController();
  final TextEditingController _dataFim = TextEditingController();
  final TextEditingController _horaFim = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? selected;
  late Future<List<Departamento>?> _futureDepts;
  bool salvo = false;
  bool isLoading = false;
  Departamento? _departamentoSelecionado;
  Integracao? resultado;
  late Future<Integracao> loadIntegracao;

  Future<bool> _salvar() async {
    if (_departamentoSelecionado == null) {
      return false;
    }

    final integracao = Integracao(
      dataInicio: _toEuaDate(_dataInicio.text),
      horaInicio: _parseTimeOfDay(_horaInicio.text),
      dataFim: _toEuaDate(_dataFim.text),
      horaFim: _parseTimeOfDay(_horaFim.text),
      departamento: _departamentoSelecionado!,
    );

    resultado = await _sendIntegracao(integracao);
    _fetchIntegracao();
    print(resultado);
    return resultado != null;
  }

  Future<Integracao?> _fetchIntegracao() async {
    await Future.delayed(const Duration(seconds: 2));
    if (resultado == null) {
      return null;
    }
    return resultado!;
  }

  Future<List<Departamento>?> _getDpts() async {
    await Future.delayed(const Duration(seconds: 2));
    var url = Uri.parse('$urlAPI/rh/listar-departamentos');
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
        return parseDepartamento(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }

  Future<Integracao?> _sendIntegracao(Integracao integracao) async {
    await Future.delayed(const Duration(seconds: 2));
    var url = Uri.parse('$urlAPI/rh/cadastrar-integracao/${widget.id}');
    String tkn = widget.token;

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $tkn",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode(integracao.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        return parseIntegracao(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _futureDepts = _getDpts();
  }

  @override
  void dispose() {
    _dataInicio.dispose();
    _horaInicio.dispose();
    _dataFim.dispose();
    _horaFim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const BannerAdmin(
                      titulo: Text(
                        "ONBOARDING",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: FontAwesomeIcons.squarePlus,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "DEPARTAMENTO ",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF757575)),
                          )),
                          const SizedBox(
                            width: 45,
                          ),
                          FutureBuilder<List<Departamento>?>(
                            future: _futureDepts,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  width: 150,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: progressSkin(20),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                    'Erro ao carregar departamentos');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('ERRO: N.E.');
                              }
                              return SizedBox(
                                width:
                                    150, // Defina uma largura fixa ou ajustável
                                child: DropdownButtonFormField<Departamento>(
                                  hint: Text(
                                    "SELECIONE",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: _departamentoSelecionado,
                                  items: snapshot.data!.map((departamento) {
                                    return DropdownMenuItem(
                                      value: departamento,
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 120),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Text(
                                            departamento.nome.toUpperCase(),
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Departamento? selecionado) {
                                    setState(() {
                                      _departamentoSelecionado = selecionado;
                                    });
                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                    return snapshot.data!
                                        .map<Widget>((departamento) {
                                      return Container(
                                        width:
                                            120, // Define a largura do item selecionado
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            departamento.nome.toUpperCase(),
                                            style: TextStyle(fontSize: 15),
                                            overflow: TextOverflow
                                                .ellipsis, // Aplica as elipses ao texto
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  validator: (value) => value == null
                                      ? 'Departamento é obrigatório'
                                      : null,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      child: Row(
                        children: [
                          campoOnboarding(
                              _dataInicio,
                              () => _selectDate(
                                    _dataInicio,
                                    firstDate: DateTime.now(),
                                    initialDate: _dataInicio.text.isNotEmpty
                                        ? _toEuaDate(_dataInicio.text)
                                        : DateTime.now(),
                                  ),
                              'Data Início',
                              true,
                              Icons.calendar_month_outlined,
                              'Data Início é obrigatória'),
                          SizedBox(
                            width: 20,
                          ),
                          campoOnboarding(
                              _horaInicio,
                              () => _selectTime(context, _horaInicio),
                              'Hora Início',
                              true,
                              Icons.timer_outlined,
                              'Hora Início é obrigatória'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      child: Row(
                        children: [
                          campoOnboarding(_dataFim, () {
                            if (_dataInicio.text.isNotEmpty) {
                              DateTime dataFimInicial =
                                  _toEuaDate(_dataInicio.text)
                                      .add(const Duration(days: 2));
                              return _selectDate(
                                _dataFim,
                                initialDate: _dataFim.text.isNotEmpty
                                    ? _toEuaDate(_dataFim.text)
                                    : dataFimInicial,
                                firstDate: dataFimInicial,
                              );
                            } else {
                              return _selectDate(
                                _dataFim,
                                initialDate: _dataFim.text.isNotEmpty
                                    ? _toEuaDate(_dataFim.text)
                                    : DateTime.now(),
                                firstDate: DateTime.now(),
                              );
                            }
                          },
                              'Data Fim',
                              _dataInicio.text.isNotEmpty,
                              Icons.calendar_month_outlined,
                              'Data Fim é obrigatória'),
                          const SizedBox(
                            width: 30,
                          ),
                          campoOnboarding(
                              _horaFim,
                              () => _selectTime(context, _horaFim),
                              'Hora Fim',
                              true,
                              Icons.timer_outlined,
                              'Hora Fim é obrigatória'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    btn_amarelo(
                      label: "Salvar",
                      funcao: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                          });
                          bool salvo = await _salvar();
                          if (salvo) {
                            await _showConfirmacaoCadastroDetails();
                            setState(() {
                              _dataInicio.clear();
                              _dataFim.clear();
                              _horaInicio.clear();
                              _horaFim.clear();
                              _departamentoSelecionado = null;
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                
                  child: Center(
                    child: progressSkin(50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future _showConfirmacaoCadastroDetails() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 200,
              height: 400,
              child: FutureBuilder<Integracao?>(
                future: _fetchIntegracao(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 150,
                      child: Align(
                        alignment: Alignment.center,
                        child: progressSkin(20),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar detalhes');
                  } else if (!snapshot.hasData || snapshot.data! == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ERRO: Nenhum dado disponível.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                    return const SizedBox(); // Retorne um widget vazio para o FutureBuilder
                  }
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                              'ONBOARDING: #${snapshot.data!.id.toString()}'),
                        ),
                        Divider(
                          color: cinza,
                        ),
                        Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("DEPARTAMENTO")),
                              ),
                              Text(snapshot.data!.departamento.nome
                                  .toUpperCase()),
                            ],
                          ),
                        ),
                        Divider(
                          color: cinza,
                        ),
                        Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("INÍCIO")),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(_toBrDate(snapshot.data!.dataInicio)),
                                  Text(_formatTimeOfDay(
                                      snapshot.data!.horaInicio)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: cinza,
                        ),
                        Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("FIM")),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(_toBrDate(snapshot.data!.dataFim)),
                                  Text(
                                      _formatTimeOfDay(snapshot.data!.horaFim)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: cinza,
                        ),
                        Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("STATUS")),
                              ),
                              Text(snapshot.data!.status!),
                            ],
                          ),
                        ),
                        Divider(
                          color: cinza,
                        ),
                        Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: Text("QTD. COLABORADORES")),
                              ),
                              Text(snapshot.data!.qtdColaboradores.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  Future<void> _selectDate(
    TextEditingController data, {
    required DateTime initialDate,
    required DateTime firstDate, // Adicionar o parâmetro firstDate
  }) async {
    DateTime? _selected = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      initialDate: initialDate,
      locale: const Locale('pt', 'BR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: amareloEuro,
              onPrimary: azulEuro,
              onSurface: azulEuro,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: azulEuro,
              ),
            ),
            dialogBackgroundColor: Colors.white,
            datePickerTheme: const DatePickerThemeData(
                todayBorder: BorderSide(
                  color: azulEuro, // Define a cor da borda do dia atual
                  width: 2, // Define a espessura da borda
                ),
                shadowColor: azulEuro),
          ),
          child: child!,
        );
      },
    );

    if (_selected != null) {
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(_selected);
        data.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController hora,
  ) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: azulEuro,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            timePickerTheme: const TimePickerThemeData(
              dialBackgroundColor: Colors.white,
              dialHandColor: azulEuro,
              hourMinuteTextColor: azulEuro,
              dayPeriodTextColor: azulEuro,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null && selectedTime != _selectedTime) {
      setState(() {
        _selectedTime = selectedTime;
        hora.text = _formatTimeOfDay(_selectedTime);
      });
    }
  }
}

DateTime _toEuaDate(String data) {
  return DateFormat('dd/MM/yyyy').parse(data);
}

String _toBrDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

Widget campoOnboarding(
  TextEditingController textController,
  Future<void> Function() funcao,
  String label,
  bool isEnable,
  IconData icon,
  String validationMessage,
) {
  return Expanded(
    child: TextFormField(
      controller: textController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      enabled: isEnable,
      onTap: () async {
        await funcao();
      },
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: cinza, width: 2.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: azulEuro, width: 2.0),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? validationMessage : null,
    ),
  );
}

class Integracao {
  int? id;
  DateTime dataInicio;
  TimeOfDay horaInicio;
  DateTime dataFim;
  TimeOfDay horaFim;
  String? status;
  int? qtdColaboradores;
  Departamento departamento;

  Integracao(
      {this.id,
      required this.dataInicio,
      required this.horaInicio,
      required this.dataFim,
      required this.horaFim,
      this.status,
      this.qtdColaboradores,
      required this.departamento});

  factory Integracao.fromJson(Map<String, dynamic> json) {
    return Integracao(
        id: json['id'],
        dataInicio: DateFormat('yyyy-MM-dd').parse(json['dataInicio']),
        horaInicio: _parseTimeOfDay(json['horaInicio']),
        dataFim: DateFormat('yyyy-MM-dd').parse(json['dataFim']),
        horaFim: _parseTimeOfDay(json['horaFim']),
        status: json['status'],
        qtdColaboradores: json['qtdColaboradores'],
        departamento: Departamento.fromJson(json['departamento']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataInicio': DateFormat('yyyy-MM-dd').format(dataInicio),
      'horaInicio': _formatTimeOfDay(horaInicio),
      'dataFim': DateFormat('yyyy-MM-dd').format(dataFim),
      'horaFim': _formatTimeOfDay(horaFim),
      'departamento': departamento.toJson()
    };
  }
}

class Departamento {
  int id;
  String nome;

  Departamento({required this.id, required this.nome});

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}

List<Departamento> parseDepartamento(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Departamento>((json) => Departamento.fromJson(json))
      .toList();
}

Integracao parseIntegracao(String responseBody) {
  final Map<String, dynamic> json = jsonDecode(responseBody);
  return Integracao.fromJson(json);
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
