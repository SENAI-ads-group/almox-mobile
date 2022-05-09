import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  static final HomeController _instance = HomeController.internal();
  factory HomeController() => _instance;
  HomeController.internal();

  FloatingActionButton? floatingActionButton;
  final ChangeNotifier indexPaginaChangeNotifier = ChangeNotifier();
  int _indexPaginaAtual = 0;

  int get indexPaginaAtual {
    return _indexPaginaAtual;
  }

  set indexPaginaAtual(int index) {
    _indexPaginaAtual = index;
    indexPaginaChangeNotifier.notifyListeners();
  }

  setBotaoAcao({FloatingActionButton? floatingActionButton}) {
    this.floatingActionButton = floatingActionButton;
  }
}
