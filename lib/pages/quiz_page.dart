import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modulo_a1_pr/global/cores.dart';
import 'package:modulo_a1_pr/global/variaveis.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  PageController pageController = PageController();
  int paginaAtual = 0,
      perguntaAtual = 0,
      alternativaSelecionada = -1,
      scoreTotal = 0;
  List<dynamic> alternativas = [];
  bool confirmar = false, entradaVF = false;
  String tipoAtual = '';
  double valorRotacao = 1.0;
  EventChannel eventSensor = EventChannel('$caminhoCanal/sensor');

  @override
  void initState() {
    super.initState();
    contexto = context;
    iniciar();
  }

  void iniciar() async {
    eventSensor.receiveBroadcastStream().listen((value) {
      if (paginaAtual == 1 && !entradaVF) {
        if (value > 3) {
          setState(() {
            alternativaSelecionada = 0;
          });
        } else if (value < 3 && value > 0) {
          setState(() {
            alternativaSelecionada = 1;
          });
        }
      }
    });
  }

  void encerrar() async {
    Navigator.pop(context);
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: corClara,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(
                'Score Total',
                style: TextStyle(
                  color: corEscuro,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                scoreTotal.toString(),
                style: TextStyle(
                  color: corEscuro,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void proximo() async {
    if (!confirmar) {
      confirmar = true;
      mostrarResposta();
    } else {
      alternativaSelecionada = -1;
      confirmar = false;
      perguntaAtual++;
      if (listQuiz[perguntaAtual]['tipo'] != tipoAtual) {
        paginaAtual++;
        pageController.animateToPage(
          paginaAtual,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        if (paginaAtual == 1) {
          animacaoEntradaVF();
        }
      }
    }
    setState(() {});
  }

  void animacaoEntradaVF() async {
    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        entradaVF = true;
      });
    });
    await Future.delayed(Duration(seconds: 1), () {
      valorRotacao = 1.2;
      alternativaSelecionada = 1;
      setState(() {});
    });
    await Future.delayed(Duration(seconds: 1), () {
      valorRotacao = 1.0;
      alternativaSelecionada = 0;
      setState(() {});
    });
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        entradaVF = false;
        alternativaSelecionada = -1;
      });
    });
  }

  void mostrarResposta() async {
    if (alternativaSelecionada ==
        listQuiz[perguntaAtual]['resposta']) {
      int peso = listQuiz[perguntaAtual]['peso'];
      scoreTotal = scoreTotal + peso;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      paginaAtual == 2
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.portraitUp,
    ]);

    alternativas = listQuiz[perguntaAtual]['alternativas'];
    tipoAtual = listQuiz[perguntaAtual]['tipo'];
    return Scaffold(
      appBar: AppBar(
        foregroundColor: corRoxoMedio,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Quiz My Brain',
          style: TextStyle(
            color: corRoxoMedio,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Container(
            child: paginaAtual == 0
                ? SafeArea(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: Column(
                        spacing: 10,
                        children: [
                          Text(
                            listQuiz[perguntaAtual]['enunciado'],
                            style: TextStyle(
                              color: corRoxoMedio,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            children: List.generate(4, (index) {
                              return ListTile(
                                onTap: !confirmar
                                    ? () {
                                        setState(() {
                                          alternativaSelecionada =
                                              index;
                                        });
                                      }
                                    : null,
                                title: Text(
                                  '${index == 0
                                      ? 'a)'
                                      : index == 1
                                      ? 'b)'
                                      : index == 2
                                      ? 'c)'
                                      : 'd)'} ${alternativas[index]}',
                                  style: TextStyle(
                                    color:
                                        listQuiz[perguntaAtual]['resposta'] ==
                                                index &&
                                            confirmar
                                        ? Colors.green
                                        : alternativaSelecionada ==
                                              index
                                        ? corRoxoMedio
                                        : corEscuro,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
          Container(
            child: paginaAtual == 1
                ? SafeArea(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            listQuiz[perguntaAtual]['enunciado'],
                            style: TextStyle(
                              color: corRoxoMedio,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            spacing: 40,
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                'Verdadeiro',
                                style: TextStyle(
                                  color:
                                      listQuiz[perguntaAtual]['resposta'] ==
                                              0 &&
                                          confirmar
                                      ? Colors.green
                                      : alternativaSelecionada == 0
                                      ? corRoxoMedio
                                      : corEscuro,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Falso',
                                style: TextStyle(
                                  color:
                                      listQuiz[perguntaAtual]['resposta'] ==
                                              1 &&
                                          confirmar
                                      ? Colors.green
                                      : alternativaSelecionada == 1
                                      ? corRoxoMedio
                                      : corEscuro,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AnimatedOpacity(
                            opacity: entradaVF ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: AnimatedRotation(
                              turns: valorRotacao,
                              curve: Curves.easeInOut,
                              duration: Duration(seconds: 1),
                              child: Icon(
                                Icons.screen_rotation,
                                color: corEscuro,
                                size: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
          Container(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: encerrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corRoxoMedio,
                  foregroundColor: corClara,
                ),
                child: Text('Encerrar'),
              ),
              ElevatedButton(
                onPressed: alternativaSelecionada > -1 && !entradaVF
                    ? proximo
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corRoxoMedio,
                  foregroundColor: corClara,
                ),
                child: Text('Próximo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
