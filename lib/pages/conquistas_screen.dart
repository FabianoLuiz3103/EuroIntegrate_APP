import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:eurointegrate_app/components/consts.dart';
import 'package:eurointegrate_app/model/conquista.dart';

class ConquistasScreen extends StatefulWidget {
  final String token;
  const ConquistasScreen({super.key, required this.token});

  @override
  State<ConquistasScreen> createState() => _ConquistasScreenState();
}

class _ConquistasScreenState extends State<ConquistasScreen> {
  int myPoints = 100; //puxar da API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conquistas"),
        backgroundColor: azulEuro,
      ),
      body: FutureBuilder<List<Conquista>>(
        future:
            loadConquistas(), // Certifique-se de que esta função está definida
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar conquistas"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma conquista disponível"));
          } else {
            final conquistas = snapshot.data!;
            return ListView.separated(
              itemCount: conquistas.length,
              itemBuilder: (context, index) {
                final isUnlocked = myPoints >= conquistas[index].pontos;
                return Stack(
                  children: [
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(conquistas[index].image),
                      ),
                      title: Text(conquistas[index].titulo),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding:
                                    EdgeInsets.zero, 
                                content: SizedBox(
                                  width: 200, 
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, 
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                conquistas[index].image),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        conquistas[index].titulo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(conquistas[index].descricao, style: TextStyle(), textAlign: TextAlign.center,),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: isUnlocked
                            ? const Icon(Icons.arrow_forward_ios)
                            : const Icon(Icons.block, color: Colors.white),
                      ),
                    ),
                    if (!isUnlocked)
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.black.withOpacity(0.03),
                            ),
                          ),
                        ),
                      ),
                    if (!isUnlocked)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.star, color: Colors.amber),
                                ),
                                Text(
                                  conquistas[index].pontos.toString(),
                                  style: const TextStyle(color: azulEuro),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(); // Adiciona um divisor entre os itens
              },
            );
          }
        },
      ),
    );
  }
}
