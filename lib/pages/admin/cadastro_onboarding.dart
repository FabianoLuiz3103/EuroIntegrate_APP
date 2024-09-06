import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CadastroOnboardingScreen extends StatefulWidget {
  const CadastroOnboardingScreen({super.key});

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
  late Future<List<Departamento>> _futureDepts;
  bool salvo = false;
  bool isLoading = false;

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
                    const BannerAdmin(titulo:Text(
                    "ONBOARDING",
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600,), ),
                  icon: FontAwesomeIcons.squarePlus,),
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
                            style: TextStyle(fontSize: 15, color: Color(0xFF757575)),
                          )),
                          const SizedBox(
                            width: 45,
                          ),
                          FutureBuilder<List<Departamento>>(
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
                                return const Text(
                                    'Nenhum departamento encontrado');
                              }
                              return SizedBox(
                                width:
                                    150, // Defina uma largura fixa ou ajustável
                                child: DropdownButtonFormField<String>(
                                  hint: Text(
                                    "SELECIONE",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: selected,
                                  items: snapshot.data!.map((departamento) {
                                    return DropdownMenuItem(
                                      value: departamento.id.toString(),
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
                                  onChanged: (String? selectedDepartamento) {
                                    setState(() {
                                      selected = selectedDepartamento;
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
                              selected = null;
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
              Container(
                color: Colors.black54,
                child: progressSkin(30),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _salvar() async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }

  Future _showConfirmacaoCadastroDetails() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Row(
                      children: [
                        Text(_dataInicio.text),
                        Text(_horaInicio.text)
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [Text(_dataFim.text), Text(_horaFim.text)],
                    ),
                  ),
                  const Center(
                    child: Text("DEPARTAMENTO"),
                  )
                ],
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

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm')
        .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formattedTime;
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

class Departamento {
  int id;
  String nome;

  Departamento({required this.id, required this.nome});
}

Future<List<Departamento>> _getDpts() async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Departamento(id: 1, nome: 'Tecnologia da informação (TI)'),
    Departamento(id: 2, nome: 'Financeiro'),
    Departamento(id: 3, nome: 'Marketing'),
    Departamento(id: 4, nome: 'Recursos Humanos (RH)'),
    Departamento(id: 5, nome: 'Riscos')
  ];
}
