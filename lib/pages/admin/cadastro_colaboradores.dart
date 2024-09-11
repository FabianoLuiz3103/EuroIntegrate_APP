import 'dart:convert';
import 'dart:io';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/components/progress.dart';
import 'package:eurointegrate_app/pages/admin/components/banner.dart';
import 'package:eurointegrate_app/pages/admin/components/rounded_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CadastroColaboradoresScreen extends StatefulWidget {
  const CadastroColaboradoresScreen({super.key});

  @override
  State<CadastroColaboradoresScreen> createState() =>
      _CadastroColaboradoresScreenState();
}

class _CadastroColaboradoresScreenState
    extends State<CadastroColaboradoresScreen> {
  List<Colaborador> _colaboradores = [];
  String? filePath;
  List<Colaborador> readToApi = [];

  bool _isLoading = true;
  String? _errorMessage;

  Future<List<Colaborador>?> _getColaboradores() async {
    var url = Uri.parse('$urlAPI/rh/listar-colaboradores');
    String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUEkgRXVyb0ludGVncmF0ZSIsInN1YiI6ImZhYWg3NzJAZ21haWwuY29tIiwiZXhwIjoxNzI1OTkyMDk1fQ.Ih17yDFoK_SsB7dmR1GtvXEEt5Ks2l6dP6i7wBhkrq8";

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
        return parseColaboradores(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }






  Future<List<Colaborador>?> _sendColaboradores(List<Colaborador> colaboradores) async {
  setState(() {
    _isLoading = true;  // Inicia o estado de carregamento
  });

  var url = Uri.parse('$urlAPI/rh/cadastrar-colaboradores');
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUEkgRXVyb0ludGVncmF0ZSIsInN1YiI6ImZhYWg3NzJAZ21haWwuY29tIiwiZXhwIjoxNzI1OTkyMDk1fQ.Ih17yDFoK_SsB7dmR1GtvXEEt5Ks2l6dP6i7wBhkrq8";

  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(
          colaboradores.map((colaborador) => colaborador.toJson()).toList()),
      
    );
       await Future.delayed(
        const Duration(seconds: 2));

print(response.statusCode);
    if (response.statusCode == 201) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Colaboradores cadastrados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
     
      

      List<Colaborador> colaboradoresCadastrados = parseColaboradores(utf8.decode(response.bodyBytes));
      setState(() {
        _colaboradores = colaboradoresCadastrados;
        _isLoading = false;  // Finaliza o estado de carregamento
      });

     
    } else {
      setState(() {
        _isLoading = false;  // Finaliza o estado de carregamento
      });

    }
  } catch (e) {
    setState(() {
      _isLoading = false;  // Finaliza o estado de carregamento
    });
  }
}


  @override
  void initState() {
    super.initState();
    _fetchColaboradores();
  }

  Future<void> _fetchColaboradores() async {
    try {
      final colaboradores = await _getColaboradores();
      setState(() {
        readToApi = colaboradores!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 150,
            child: Align(
              alignment: Alignment.center,
              child: progressSkin(30),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(_errorMessage!)),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BannerAdmin(
              titulo: Text(
                "COLABORADORES",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: FontAwesomeIcons.userPlus,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: Text(
                "Faça aqui o upload do .XLSX/.XLS para o cadastro dos novos colaboradores",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            btn_amarelo(label: 'Carregar arquivo', funcao: _pickFile),
            const SizedBox(
              height: 20,
            ),
            if (_colaboradores.isNotEmpty)
              const Text(
                "COLABORADORES RECÉM ADICIONADOS:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _colaboradores.length,
                itemBuilder: (_, index) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        "${_colaboradores[index].nome} ${_colaboradores[index].sobrenome}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "DEPARTAMENTO: ${_colaboradores[index].departamento.nome}  -----  RM: ${_colaboradores[index].matricula}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result == null) return;

    List<List<dynamic>> fields = [];

    filePath = kIsWeb ? result.files.first.name : result.files.first.path!;

    if (!filePath!.endsWith('.xls') && !filePath!.endsWith('.xlsx')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Por favor, selecione um arquivo .xls ou .xlsx.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (kIsWeb) {
      final bytes = result.files.first.bytes!;
      var excel = Excel.decodeBytes(bytes);
      fields = _processExcel(excel);
    } else {
      var bytes = File(filePath!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      fields = _processExcel(excel);
    }

    if (!_validateHeaders(fields)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: O arquivo XLS não contém as colunas corretas.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<String> errorMessages = [];
    List<List<dynamic>> validRows = [];

    Set<String> emails = {};
    Set<String> telefones = {};
    Set<String> cpfs = {};

    for (int i = 0; i < fields.length; i++) {
      var row = fields[i];
      if (row.isEmpty ||
          row.every((element) =>
              element == null || element.toString().trim().isEmpty)) {
        continue;
      }

      if (row.length < 9) {
        errorMessages.add('Linha ${i + 1}: Número insuficiente de colunas.');
        continue;
      }

      // Valida a unicidade de CPF, email e telefone
      String email = row[3].toString().trim();
      String telefone = row[4].toString().trim();
      String cpf = row[2].toString().trim();

      if (emails.contains(email)) {
        errorMessages.add('Linha ${i + 1}: E-mail duplicado');
      } else {
        emails.add(email);
      }

      if (telefones.contains(telefone)) {
        errorMessages.add('Linha ${i + 1}: Telefone duplicado');
      } else {
        telefones.add(telefone);
      }

      if (cpfs.contains(cpf)) {
        errorMessages.add('Linha ${i + 1}: CPF duplicado');
      } else {
        cpfs.add(cpf);
      }

      bool colaboradorExiste = readToApi.any((colaborador) =>
          colaborador.cpf == cpf ||
          colaborador.email == email ||
          colaborador.telefone == telefone);

      if (colaboradorExiste) {
        errorMessages
            .add('Linha ${i + 1}: Colaborador já existe na base de dados');
        continue;
      }

      var errors = _validateRow(row);
      if (errors.isNotEmpty) {
        errorMessages.add('Linha ${i + 1}: ${errors.join(", ")}');
        continue;
      }

      validRows.add(row);
    }

    if (errorMessages.isNotEmpty) {
      _showErrorDialog(errorMessages);
    } else {
      setState(() {
        _colaboradores = _mapCsvToColaboradores(validRows);
      });
      await _sendColaboradores(_colaboradores);
     _fetchColaboradores();
    }
  }

  void _showErrorDialog(List<String> errorMessages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erros de Validação'),
          content: SizedBox(
            width: double.maxFinite,
            height: 100,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Erros encontrados:\n${errorMessages.join("\n")}'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<List<dynamic>> _processExcel(Excel excel) {
    List<List<dynamic>> rows = [];
    for (var table in excel.tables.keys) {
      if (excel.tables[table] != null) {
        for (var row in excel.tables[table]!.rows) {
          rows.add(row.map((cell) => cell?.value).toList());
        }
      }
    }
    return rows;
  }

  bool _validateHeaders(List<List<dynamic>> fields) {
    if (fields.isEmpty) return false;

    final headers = fields.first
        .map((header) => header.toString().toLowerCase().trim())
        .toList();

    const requiredHeaders = [
      'nome',
      'sobrenome',
      'cpf',
      'email',
      'telefone',
      'dataadmissao',
      'matricula',
      'datanascimento',
      'departamento'
    ];

    if (headers.length != requiredHeaders.length) {
      return false;
    }

    for (int i = 0; i < requiredHeaders.length; i++) {
      if (headers[i] != requiredHeaders[i]) {
        return false;
      }
    }

    fields.removeAt(0);

    return true;
  }

  List<String> _validateRow(List<dynamic> row) {
    List<String> errors = [];

    if (!RegExp(r'^\d{11}$').hasMatch(row[2].toString())) {
      errors.add('CPF inválido');
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(row[3].toString())) {
      errors.add('E-mail inválido');
    }

    if (!_isTodayOrPastDate(_formatData(row[5].toString()))) {
      errors.add(
          'Data de admissão inválida - a data de admissão deve ter como limite o dia de hoje!');
    }
    if (!_isOver18YearsOld(_formatData(row[7].toString()))) {
      errors.add(
          'Data de nascimento inválida - o colaborador DEVE ter mais de 18 anos!');
    }

    int idDept = _dptNameToIdDept(row[8].toString());
    if (idDept == 0) {
      errors.add('Departamento inválido');
    }

    return errors;
  }

  DateTime _formatData(String data) {
    var _dt = DateTime.parse(data);
    return DateTime.parse(DateFormat("yyyy-MM-dd").format(_dt));
  }

  bool _isOver18YearsOld(DateTime date) {
    final today = DateTime.now();
    final eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);
    return date.isBefore(eighteenYearsAgo);
  }

  bool _isTodayOrPastDate(DateTime date) {
    final today = DateTime.now();
    final todayWithoutTime = DateTime(today.year, today.month, today.day);
    final dateWithoutTime = DateTime(date.year, date.month, date.day);
    return dateWithoutTime.isBefore(todayWithoutTime) ||
        dateWithoutTime.isAtSameMomentAs(todayWithoutTime);
  }

  int _dptNameToIdDept(String departamento) {
    switch (departamento.toLowerCase()) {
      case 'tecnologia da informação (ti)':
        return 1;
      case 'financeiro':
        return 2;
      case 'marketing':
        return 3;
      case 'jurídico':
        return 4;
      case 'recursos humanos (rh)':
        return 5;
      case 'riscos':
        return 6;
      default:
        return 0;
    }
  }

  Departamento _nomeDptToDepartamento(String departamento) {
    switch (departamento.toLowerCase()) {
      case 'tecnologia da informação (ti)':
        return Departamento(id: 1, nome: departamento);
      case 'financeiro':
        return Departamento(id: 1, nome: departamento);
      case 'marketing':
        return Departamento(id: 1, nome: departamento);
      case 'jurídico':
        return Departamento(id: 1, nome: departamento);
      case 'recursos humanos (rh)':
        return Departamento(id: 1, nome: departamento);
      case 'riscos':
        return Departamento(id: 1, nome: departamento);
      default:
        return Departamento(id: 9, nome: 'NE');
    }
  }

  String _idDeptToDptName(int idDept) {
    switch (idDept) {
      case 1:
        return 'tecnologia da informação (ti)'.toUpperCase();
      case 2:
        return 'financeiro'.toUpperCase();
      case 3:
        return 'marketing'.toUpperCase();
      case 4:
        return 'jurídico'.toUpperCase();
      case 5:
        return 'recursos humanos (rh)'.toUpperCase();
      case 6:
        return 'riscos'.toUpperCase();
      default:
        return 'não encontrado'.toUpperCase();
    }
  }

  List<Colaborador> _mapCsvToColaboradores(List<List<dynamic>> fields) {
    try {
      return fields.map((row) {
        Departamento dept = _nomeDptToDepartamento(row[8].toString());

        return Colaborador(
          nome: row[0].toString(),
          sobrenome: row[1].toString(),
          cpf: cleanCpf(row[2].toString()),
          email: row[3].toString(),
          telefone: row[4].toString(),
          dataAdmissao: DateTime.parse(row[5].toString()),
          matricula: row[6].toString(),
          dataNascimento: DateTime.parse(row[7].toString()),
          departamento: dept,
        );
      }).toList();
    } catch (e) {
      print('Erro ao processar o arquivo: $e');
      return [];
    }
  }
}

class Departamento {
  int id;
  String nome;

  Departamento({
    required this.id,
    required this.nome,
  });

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

// Classe Colaborador
class Colaborador {
  String nome;
  String sobrenome;
  String cpf;
  String email;
  String telefone;
  DateTime dataAdmissao;
  String matricula;
  DateTime dataNascimento;
  Departamento departamento;

  Colaborador({
    required this.nome,
    required this.sobrenome,
    required this.cpf,
    required this.email,
    required this.telefone,
    required this.dataAdmissao,
    required this.matricula,
    required this.dataNascimento,
    required this.departamento,
  });

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      cpf: cleanCpf(json['cpf']),
      email: json['email'],
      telefone: json['telefone'],
      dataAdmissao: DateTime.parse(json['dataAdmissao']),
      matricula: json['matricula'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
      departamento: Departamento.fromJson(json['departamento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'email': email,
      'telefone': telefone,
      'dataAdmissao': dataAdmissao.toIso8601String(),
      'matricula': matricula,
      'dataNascimento': dataNascimento.toIso8601String(),
      'departamento': departamento.toJson(),
      'colaboradorRh': {
        'id':
            1, 
        'email': 'faah772@gmail.com'
      },
    };
  }
}

List<Colaborador> parseColaboradores(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Colaborador>((json) => Colaborador.fromJson(json)).toList();
}

String cleanCpf(String cpf) {
  return cpf.replaceAll(RegExp(r'[.-]'), '');
}
