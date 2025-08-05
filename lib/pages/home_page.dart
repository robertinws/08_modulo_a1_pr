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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.amber);
  }
}
