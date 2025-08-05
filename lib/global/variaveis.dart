import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool popBateria = false, conexaoInternet = false;
Battery battery = Battery();
String caminhoCanal = 'com.example.modulo_a1_pr';
EventChannel eventInternet = EventChannel('$caminhoCanal/internet'),
    eventFones = EventChannel('$caminhoCanal/fones');
BuildContext? contexto;
