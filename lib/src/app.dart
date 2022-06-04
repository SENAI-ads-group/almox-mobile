import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/minhas_requisicoes/minhas_requisicoes_boc.dart';
import 'pages/login/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MinhasRequisicoesBloc()),
      ],
      child: LoginPage(),
    );
  }
}
