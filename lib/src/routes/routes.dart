import 'package:almox_mobile/src/pages/atender_requisicao/atender_requisicao_page.dart';
import 'package:almox_mobile/src/pages/criar_requisicao/criar_requisicao_page.dart';
import 'package:almox_mobile/src/pages/operador/operador_page.dart';
import 'package:almox_mobile/src/pages/selecionar_produtos/selecionar_produtos_page.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/pages/home/home_page.dart';
import 'package:almox_mobile/src/pages/login/login_page.dart';

Map<String, WidgetBuilder> routes = {
  '/home': (context) => HomePage(),
  '/criarRequisicao': (context) => CriarRequisicaoPage(),
  '/login': (context) => LoginPage(),
  '/selecionarProdutos': (context) => SelecionarProdutosPage(),
  '/atenderRequisicao': (context) => AtenderRequisicaoPage(),
  '/operador': (context) => OperadorPage(),
};
