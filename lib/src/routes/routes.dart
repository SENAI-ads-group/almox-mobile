import 'package:almox_mobile/src/pages/criar_requisicao/criar_requisicao_page.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/pages/home/home_page.dart';
import 'package:almox_mobile/src/pages/login/login_page.dart';

Map<String, WidgetBuilder> routes = {
  '/home': (context) => HomePage(),
  '/criarRequisicao': (context) => CriarRequisicaoPage(),
  '/login': (context) => LoginPage()
};
