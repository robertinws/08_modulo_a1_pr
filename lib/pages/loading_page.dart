import 'package:flutter/material.dart';
import 'package:modulo_a1_pr/global/variaveis.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    contexto = context;
    iniciar();
  }

  void iniciar() async {
    eventInternet.receiveBroadcastStream().listen((value) {
      conexaoInternet = (value == 1);
    });
    eventFones.receiveBroadcastStream().listen((value) async {
      if (value == 1) {
        ScaffoldMessenger.of(contexto!).showSnackBar(
          SnackBar(
            content: Text(
              'Fone de ouvido conectado, o volume do dispositivo foi diminuído em 70%',
            ),
          ),
        );
      }
    });
    battery.onBatteryStateChanged.listen((value) async {
      if (await battery.batteryLevel <= 20 && !popBateria) {
        popBateria = true;
        await showDialog(
          context: contexto!,
          builder: (_) {
            return AlertDialog(
              content: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Atenção. Bateria Baixa.'),
                  Image.asset(
                    height: 40,
                    'assets/images/bateria.png',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            );
          },
        );
        if (ModalRoute.of(context)!.settings.name == '/') {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    });
    if (await battery.batteryLevel > 20) {
      await Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
