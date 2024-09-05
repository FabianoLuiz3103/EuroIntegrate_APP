import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CadastroOnboardingScreen extends StatefulWidget {
  const CadastroOnboardingScreen({super.key});

  @override
  State<CadastroOnboardingScreen> createState() =>
      _CadastroOnboardingScreenState();
}

class _CadastroOnboardingScreenState extends State<CadastroOnboardingScreen> {
  final TextEditingController _dataInicio = TextEditingController();
  final TextEditingController _horaInicio = TextEditingController();
  final TextEditingController _dataFim = TextEditingController();
  final TextEditingController _horaFim = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.95,
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: const BoxDecoration(
                      color: amareloEuro,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cadastro de Onboarding",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
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
                    'Data Início', true),
                SizedBox(
                  width: 20,
                ),
                campoOnboarding(_horaInicio,
                    () => _selectTime(context, _horaInicio), 'Hora Início', true),
              ],
            ),
            Row(
              children: [
                campoOnboarding(
                  _dataFim,
                  () {
                    if (_dataInicio.text.isNotEmpty) {
                      DateTime dataFimInicial = _toEuaDate(_dataInicio.text)
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
                  'Data Fim', _dataInicio.text.isNotEmpty
                ),
                SizedBox(
                  width: 20,
                ),
                campoOnboarding(
                    _horaFim, () => _selectTime(context, _horaFim), 'Hora Fim', true),
              ],
            ),
            Text(_dataInicio.text),
            Text(_dataFim.text),
            Text(_horaInicio.text),
            Text(_horaFim.text)
          ],
        ),
      ),
    );
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
      BuildContext context, TextEditingController hora) async {
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

Widget campoOnboarding(TextEditingController textController,
    Future<void> Function() funcao, String label, bool isEnable) {
  return Expanded(
    child: TextField(
      controller: textController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      enabled: isEnable,
      onTap: () async {
        await funcao(); // Chama a função e aguarda sua conclusão
      },
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: cinza, width: 2.0), // Cor da linha quando não está focado
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: azulEuro, width: 2.0), // Cor da linha quando está focado
        ),
      ),
    ),
  );
}
