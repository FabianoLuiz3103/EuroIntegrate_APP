import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarTelefone extends StatefulWidget {
  final String telefone;

  const EditarTelefone({super.key, required this.telefone});

  @override
  _EditarTelefoneState createState() => _EditarTelefoneState();
}

class _EditarTelefoneState extends State<EditarTelefone> {
  late TextEditingController telefoneController;
  final phoneMask = MaskTextInputFormatter(mask: '(##) ####-####'); // Máscara de telefone
  bool isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    telefoneController = TextEditingController(
      text: phoneMask.maskText(widget.telefone),
    );

    // Adiciona listener para monitorar mudanças no campo de telefone
    telefoneController.addListener(_checkIfValuesChanged);
  }

  @override
  void dispose() {
    telefoneController.dispose();
    super.dispose();
  }

  void _checkIfValuesChanged() {
    setState(() {
      // Compara o valor atual com o valor inicial
      isSaveButtonEnabled = telefoneController.text != phoneMask.maskText(widget.telefone);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações pessoais'),
        backgroundColor: azulEuro,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0, left: 16.0, top: 20.0),
              child: Text(
                'Número de telefone',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 24.0, left: 16.0),
              child: Text(
                'Para garantir que apenas você tenha acesso à sua conta, insira seu número de telefone',
                style: TextStyle(fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prefixo',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Color(0x80424242)),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x80424242))),
                                  hintText: '+55',
                                  hintStyle: TextStyle(color: Color(0x80424242)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Telefone',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Color(0x80424242)),
                            ),
                            TextField(
                              inputFormatters: [phoneMask],
                              controller: telefoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x80424242)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: azulEuro), 
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), 
              child: SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: isSaveButtonEnabled ? () {
                    // Lógica para salvar os dados
                  } : null,
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulEuro,
                    padding: EdgeInsets.symmetric(vertical: 18), 
                  ),
                ),
              ),
            ),
            SizedBox(height: 24), 
          ],
        ),
      ),
    );
  }
}
