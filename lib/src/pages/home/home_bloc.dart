import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier {
  static final HomeBloc _instance = HomeBloc.internal();
  factory HomeBloc() => _instance;
  HomeBloc.internal();

  FloatingActionButton? floatingActionButton;
  final _IndexPaginaChangeNotifier indexPaginaChangeNotifier =
      _IndexPaginaChangeNotifier();
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

class _IndexPaginaChangeNotifier extends ChangeNotifier {}
