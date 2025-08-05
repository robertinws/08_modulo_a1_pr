import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modulo_a1_pr/global/cores.dart';
import 'package:modulo_a1_pr/global/variaveis.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    contexto = context;
    iniciar();
  }

  void iniciar() async {
    String jsonListString = await rootBundle.loadString(
      'assets/jsons/bancoQuestoes.json',
    );
    listQuiz = jsonDecode(jsonListString)['perguntas'];
    await Future.delayed(Duration(milliseconds: 500), () async {
      if (!conexaoInternet) {
        await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text(
                'Sem conexão com internet, seus dados podem não estar completamente salvos.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
      if (await battery.isInBatterySaveMode) {
        await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text(
                'Seu dispositivo está no modo economia de energia, alguns recursos podem ser limitados.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: corEscuro,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            height: 100,
                            'assets/images/rosto.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: corRoxoMedio,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      'Home',
                      style: TextStyle(
                        color: corRoxoMedio,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'QuizMyBrain',
                      style: TextStyle(
                        color: corRoxoMedio,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).pushNamed('/quiz');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'GeniusPlay',
                      style: TextStyle(
                        color: corRoxoMedio,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).pushNamed('/genius');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'MemoCheck',
                      style: TextStyle(
                        color: corRoxoMedio,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).pushNamed('/memo');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Sair',
                      style: TextStyle(
                        color: corRoxoMedio,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Image.asset(
                  height: 120,
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                Text('Bem-vindo ao Aprender+'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
