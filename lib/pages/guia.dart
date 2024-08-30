
import 'package:eurointegrate_app/components/button_navigation.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';

class GuiaScreen extends StatefulWidget {
  const GuiaScreen({super.key});

  @override
  State<GuiaScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<GuiaScreen> {
  double _globalProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guia e normas"),
        backgroundColor: azulEuro,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  children: [
                    _buildGuiaPage("Guia 2", perguntasVideo2, 2),
                    _buildGuiaPage("Guia 3", perguntasVideo3, 3),
                    _buildGuiaPage("Guia 4", perguntasVideo4, 4),
                    _buildGuiaPage("Guia 1", perguntasVideo1, 1),
                  ],
                ),
              ),
              SizedBox(height: 8,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuiaPage(String guia, List<Pergunta> perguntas, int videoIndex) {
    double progress = (_globalProgress / 1000);

    return Column(
      children: [
        // Texto de porcentagem
        // Barra de progresso
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  color: azulEuro,
                  backgroundColor: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  minHeight: 20,
                ),
              ),
              SizedBox(width: 8,),
              Text(
              "${(progress * 10).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: azulEuro,
              ),
              textAlign: TextAlign.center,
            ),
            ],
          ),
        ),
       // SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: cinza,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "NORMA 1",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "A tecnologia tem transformado radicalmente a maneira como vivemos e interagimos no mundo moderno. Desde o surgimento da internet, nossa capacidade de comunicação e acesso à informação expandiu-se exponencialmente. Hoje, é possível conectar-se com pessoas em diferentes partes do globo instantaneamente, compartilhar conhecimento e colaborar em projetos com uma facilidade antes inimaginável. "
                      "Os dispositivos móveis, como smartphones e tablets, tornaram-se extensões de nossos corpos, permitindo que permaneçamos conectados em qualquer lugar e a qualquer momento. As redes sociais, por sua vez, transformaram a maneira como nos relacionamos, criando novas formas de expressar nossas identidades e construir comunidades online. "
                      "Além disso, a inteligência artificial e o aprendizado de máquina estão revolucionando setores como saúde, finanças e educação, oferecendo soluções inovadoras para problemas complexos. No entanto, com esses avanços vêm desafios significativos, como a privacidade dos dados e o impacto da automação no mercado de trabalho. Enfrentar esses desafios de forma ética será crucial para garantir que a tecnologia continue a beneficiar a sociedade como um todo.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: cinza,
            ),
            child: PageView(
              children: perguntas.map((pergunta) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        pergunta.enunciado,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pergunta.ops.length,
                        itemBuilder: (context, index) {
                          bool isCorrect = false;
                          Color buttonColor = azulEuro;

                          if (pergunta.selectedOptionIndex == index) {
                            isCorrect = pergunta.checkAnswer(index);
                            buttonColor = isCorrect ? Colors.green : Colors.red;
                          }

                          return ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(buttonColor),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                pergunta.ops[index].texto,
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              onPressed: pergunta.isAnswered
                                  ? null
                                  : () {
                                      setState(() {
                                        _globalProgress += 20;
                                        pergunta.selectedOptionIndex = index;
                                        pergunta.isAnswered = true;
                                        pergunta.isCorrect = pergunta.checkAnswer(index);
                                      });
                                    },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}


class Pergunta {
  String enunciado = '';
  List<Opcao> ops = [];
  int? selectedOptionIndex;
  bool isAnswered = false;
  bool? isCorrect;

  Pergunta({required String enun, required List<Opcao> op}) {
    this.enunciado = enun;
    this.ops = op;
  }

  bool checkAnswer(int index) {
    return ops[index].opcao == "A"; // Supondo que "A" é a resposta correta.
  }
}

class Opcao {
  String texto = ' ';
  String opcao = ' ';
  Opcao({required String tex, required String op}) {
    this.texto = tex;
    this.opcao = op;
  }
}


// Listas de perguntas para cada vídeo
List<Pergunta> perguntasVideo1 = [
  Pergunta(
      enun:
          "QUESTÃO 1: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q1", op: "A"),
        Opcao(tex: "OPCAO B - Q1", op: "B"),
        Opcao(tex: "OPCAO C - Q1", op: "C"),
        Opcao(tex: "OPCAO D - Q1", op: "D")
      ]),
  Pergunta(
      enun:
          "QUESTÃO 2: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q2", op: "A"),
        Opcao(tex: "OPCAO B - Q2", op: "B"),
        Opcao(tex: "OPCAO C - Q2", op: "C"),
        Opcao(tex: "OPCAO D - Q2", op: "D")
      ]),
];

List<Pergunta> perguntasVideo2 = [
  Pergunta(
      enun:
          "QUESTÃO 1: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q1", op: "A"),
        Opcao(tex: "OPCAO B - Q1", op: "B"),
        Opcao(tex: "OPCAO C - Q1", op: "C"),
        Opcao(tex: "OPCAO D - Q1", op: "D")
      ]),
  Pergunta(
      enun:
          "QUESTÃO 2: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q2", op: "A"),
        Opcao(tex: "OPCAO B - Q2", op: "B"),
        Opcao(tex: "OPCAO C - Q2", op: "C"),
        Opcao(tex: "OPCAO D - Q2", op: "D")
      ]),
];

List<Pergunta> perguntasVideo3 = [
  Pergunta(
      enun:
          "QUESTÃO 1: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q1", op: "A"),
        Opcao(tex: "OPCAO B - Q1", op: "B"),
        Opcao(tex: "OPCAO C - Q1", op: "C"),
        Opcao(tex: "OPCAO D - Q1", op: "D")
      ]),
  Pergunta(
      enun:
          "QUESTÃO 2: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q2", op: "A"),
        Opcao(tex: "OPCAO B - Q2", op: "B"),
        Opcao(tex: "OPCAO C - Q2", op: "C"),
        Opcao(tex: "OPCAO D - Q2", op: "D")
      ]),
];

List<Pergunta> perguntasVideo4 = [
  Pergunta(
      enun:
          "QUESTÃO 1: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q1", op: "A"),
        Opcao(tex: "OPCAO B - Q1", op: "B"),
        Opcao(tex: "OPCAO C - Q1", op: "C"),
        Opcao(tex: "OPCAO D - Q1", op: "D")
      ]),
  Pergunta(
      enun:
          "QUESTÃO 2: Qual das alternativas abaixo está correta em relação ao tema abordado?",
      op: [
        Opcao(tex: "OPCAO A - Q2", op: "A"),
        Opcao(tex: "OPCAO B - Q2", op: "B"),
        Opcao(tex: "OPCAO C - Q2", op: "C"),
        Opcao(tex: "OPCAO D - Q2", op: "D")
      ]),
];