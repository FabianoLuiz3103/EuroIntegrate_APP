import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BulkUpload extends StatefulWidget {
  const BulkUpload({Key? key}) : super(key: key);

  @override
  State<BulkUpload> createState() => _BulkUploadState();
}

class _BulkUploadState extends State<BulkUpload> {
  List<Colaborador> _colaboradores = [];
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.95,
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cadastro de novos colaboradores",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: Text("Faça aqui o upload do .XLSX/.XLS com os novos colaboradores", textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                child: const Text(
                  "Upload File",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _pickFile,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.yellow),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), 
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            if(_colaboradores.isNotEmpty)
              Text("COLABORADORES ADICIONADOS:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
            SizedBox(height: 20,),
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
                      subtitle: Text(
                       _idDeptToDptName(_colaboradores[index].idDept),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
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
    if (row.isEmpty || row.every((element) => element == null || element.toString().trim().isEmpty)) {
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

        bool colaboradorExiste = colaboradores.any((colaborador) => colaborador.cpf == cpf);
    if (colaboradorExiste) {
      errorMessages.add('Linha ${i + 1}: Colaborador já existe na base de dados');
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

    const requiredHeaders = ['nome', 'sobrenome', 'cpf', 'email', 'telefone', 'dataadmissao', 'matricula', 'datanascimento', 'departamento'];

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
      errors.add('Data de admissão inválida - a data de admissão deve ter como limite o dia de hoje!');
    }
    if (!_isOver18YearsOld(_formatData(row[7].toString()))) {
      errors.add('Data de nascimento inválida - o colaborador DEVE ter mais de 18 anos!');
    }

    int idDept = _dptNameToIdDept(row[8].toString());
  if (idDept == 0) {
    errors.add('Departamento inválido');
  }

    return errors;
  }

  DateTime _formatData(String data){
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
  return dateWithoutTime.isBefore(todayWithoutTime) || dateWithoutTime.isAtSameMomentAs(todayWithoutTime);
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

String _idDeptToDptName(int idDept){
  switch (idDept){
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
        int idDept = _dptNameToIdDept(row[8].toString());
        
        return Colaborador(
          nome: row[0].toString(),
          sobrenome: row[1].toString(),
          cpf: row[2].toString(),
          email: row[3].toString(),
          telefone: row[4].toString(),
          dataAdmissao: DateTime.parse(row[5].toString()),
          matricula: row[6].toString(),
          dataNascimento: DateTime.parse(row[7].toString()),
          idDept: idDept
        );
      }).toList();
    } catch (e) {
      print('Erro ao processar o arquivo: $e');
      return [];
    }
  }
}

class Colaborador {
  String nome;
  String sobrenome;
  String cpf;
  String email;
  String telefone;
  DateTime dataAdmissao;
  String matricula;
  DateTime dataNascimento;
  int idDept;

  Colaborador({
    required this.nome,
    required this.sobrenome,
    required this.cpf,
    required this.email,
    required this.telefone,
    required this.dataAdmissao,
    required this.matricula, 
    required this.dataNascimento,
    required this.idDept
  });
}




 final colaboradores = <Colaborador>[
    Colaborador(
      nome: 'Ana',
      sobrenome: 'Silva',
      cpf: '12345678901',
      email: 'ana.silva@example.com',
      telefone: '+55 1122334455',
      dataAdmissao: DateTime(2023, 1, 15),
      matricula: '000001',
      dataNascimento: DateTime(1990, 5, 12),
      idDept: 1,
    ),
    Colaborador(
      nome: 'Carlos',
      sobrenome: 'Santos',
      cpf: '23456789012',
      email: 'carlos.santos@example.com',
      telefone: '+55 2233445566',
      dataAdmissao: DateTime(2022, 3, 20),
      matricula: '000002',
      dataNascimento: DateTime(1985, 8, 24),
      idDept: 2,
    ),
    Colaborador(
      nome: 'Maria',
      sobrenome: 'Oliveira',
      cpf: '34567890123',
      email: 'maria.oliveira@example.com',
      telefone: '+55 3344556677',
      dataAdmissao: DateTime(2024, 7, 30),
      matricula: '000003',
      dataNascimento: DateTime(1992, 12, 8),
      idDept: 3,
    ),
    Colaborador(
      nome: 'José',
      sobrenome: 'Pereira',
      cpf: '45678901234',
      email: 'jose.pereira@example.com',
      telefone: '+55 4455667788',
      dataAdmissao: DateTime(2021, 11, 5),
      matricula: '000004',
      dataNascimento: DateTime(1980, 6, 15),
      idDept: 4,
    ),
    Colaborador(
      nome: 'Patrícia',
      sobrenome: 'Almeida',
      cpf: '56789012345',
      email: 'patricia.almeida@example.com',
      telefone: '+55 5566778899',
      dataAdmissao: DateTime(2023, 2, 14),
      matricula: '000005',
      dataNascimento: DateTime(1987, 4, 20),
      idDept: 5,
    ),
    Colaborador(
      nome: 'Paulo',
      sobrenome: 'Costa',
      cpf: '67890123456',
      email: 'paulo.costa@example.com',
      telefone: '+55 6677889900',
      dataAdmissao: DateTime(2022, 9, 25),
      matricula: '000006',
      dataNascimento: DateTime(1991, 11, 1),
      idDept: 6,
    ),
    Colaborador(
      nome: 'Fernanda',
      sobrenome: 'Ferreira',
      cpf: '78901234567',
      email: 'fernanda.ferreira@example.com',
      telefone: '+55 7788990011',
      dataAdmissao: DateTime(2024, 5, 16),
      matricula: '000007',
      dataNascimento: DateTime(1994, 7, 7),
      idDept: 1,
    ),
    Colaborador(
      nome: 'Lucas',
      sobrenome: 'Rodrigues',
      cpf: '89012345678',
      email: 'lucas.rodrigues@example.com',
      telefone: '+55 8899001122',
      dataAdmissao: DateTime(2023, 8, 22),
      matricula: '000008',
      dataNascimento: DateTime(1995, 3, 30),
      idDept: 2,
    ),
    Colaborador(
      nome: 'Juliana',
      sobrenome: 'Martins',
      cpf: '90123456789',
      email: 'juliana.martins@example.com',
      telefone: '+55 9900112233',
      dataAdmissao: DateTime(2022, 6, 10),
      matricula: '000009',
      dataNascimento: DateTime(1988, 9, 5),
      idDept: 3,
    ),
    Colaborador(
      nome: 'Roberto',
      sobrenome: 'Gomes',
      cpf: '01234567890',
      email: 'roberto.gomes@example.com',
      telefone: '+55 1001223344',
      dataAdmissao: DateTime(2021, 12, 19),
      matricula: '000010',
      dataNascimento: DateTime(1982, 10, 17),
      idDept: 4,
    ),
    Colaborador(
      nome: 'Mariana',
      sobrenome: 'Silva',
      cpf: '12345678912',
      email: 'mariana.silva@example.com',
      telefone: '+55 2112334455',
      dataAdmissao: DateTime(2024, 3, 12),
      matricula: '000011',
      dataNascimento: DateTime(1993, 1, 21),
      idDept: 5,
    ),
    Colaborador(
      nome: 'Gabriel',
      sobrenome: 'Santos',
      cpf: '23456789023',
      email: 'gabriel.santos@example.com',
      telefone: '+55 3223445566',
      dataAdmissao: DateTime(2023, 4, 25),
      matricula: '000012',
      dataNascimento: DateTime(1990, 6, 18),
      idDept: 6,
    ),
    Colaborador(
      nome: 'Claudia',
      sobrenome: 'Oliveira',
      cpf: '34567890134',
      email: 'claudia.oliveira@example.com',
      telefone: '+55 4334556677',
      dataAdmissao: DateTime(2022, 7, 14),
      matricula: '000013',
      dataNascimento: DateTime(1984, 2, 2),
      idDept: 1,
    ),
    Colaborador(
      nome: 'Eduardo',
      sobrenome: 'Pereira',
      cpf: '45678901245',
      email: 'eduardo.pereira@example.com',
      telefone: '+55 5445667788',
      dataAdmissao: DateTime(2024, 1, 29),
      matricula: '000014',
      dataNascimento: DateTime(1986, 12, 27),
      idDept: 2,
    ),
    Colaborador(
      nome: 'Tatiane',
      sobrenome: 'Almeida',
      cpf: '56789012356',
      email: 'tatiane.almeida@example.com',
      telefone: '+55 6556778899',
      dataAdmissao: DateTime(2021, 10, 11),
      matricula: '100015',
      dataNascimento: DateTime(1992, 8, 16),
      idDept: 3,
    ),
    Colaborador(
      nome: 'Rafael',
      sobrenome: 'Costa',
      cpf: '67890123467',
      email: 'rafael.costa@example.com',
      telefone: '+55 7667889900',
      dataAdmissao: DateTime(2023, 6, 23),
      matricula: '000016',
      dataNascimento: DateTime(1989, 4, 9),
      idDept: 4,
    ),
    Colaborador(
      nome: 'Luana',
      sobrenome: 'Ferreira',
      cpf: '78901234578',
      email: 'luana.ferreira@example.com',
      telefone: '+55 8778990011',
      dataAdmissao: DateTime(2024, 7, 5),
      matricula: '000017',
      dataNascimento: DateTime(1996, 11, 15),
      idDept: 5,
    ),
    Colaborador(
      nome: 'Marcos',
      sobrenome: 'Rodrigues',
      cpf: '89012345689',
      email: 'marcos.rodrigues@example.com',
      telefone: '+55 9889001122',
      dataAdmissao: DateTime(2022, 9, 14),
      matricula: '000018',
      dataNascimento: DateTime(1988, 5, 19),
      idDept: 6,
    ),
    Colaborador(
      nome: 'Beatriz',
      sobrenome: 'Martins',
      cpf: '90123456790',
      email: 'beatriz.martins@example.com',
      telefone: '+55 1999002233',
      dataAdmissao: DateTime(2021, 11, 6),
      matricula: '000019',
      dataNascimento: DateTime(1994, 7, 21),
      idDept: 1,
    ),
    Colaborador(
      nome: 'Fernando',
      sobrenome: 'Gomes',
      cpf: '01234567891',
      email: 'fernando.gomes@example.com',
      telefone: '+55 2100223344',
      dataAdmissao: DateTime(2023, 8, 4),
      matricula: '000020',
      dataNascimento: DateTime(1983, 3, 12),
      idDept: 2,
    ),
  ];