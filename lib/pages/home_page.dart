import 'package:flutter/material.dart';
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
    return Scaffold();
  }
}
