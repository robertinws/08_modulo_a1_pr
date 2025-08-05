import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modulo_a1_pr/pages/genius_page.dart';
import 'package:modulo_a1_pr/pages/home_page.dart';
import 'package:modulo_a1_pr/pages/loading_page.dart';
import 'package:modulo_a1_pr/pages/memo_page.dart';
import 'package:modulo_a1_pr/pages/quiz_page.dart';

class AppController extends StatelessWidget {
  const AppController({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
        '/home': (context) => HomePage(),
        '/quiz': (context) => QuizPage(),
        '/genius': (context) => GeniusPage(),
        '/memo': (context) => MemoPage(),
      },
    );
  }
}
