import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier {
  static final HomeBloc _instance = HomeBloc.internal();
  factory HomeBloc() => _instance;
  HomeBloc.internal();

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
