import 'package:almox_mobile/src/bloc/minhas_requisicoes/minhas_requisicoes_boc.dart';
import 'package:almox_mobile/src/bloc/minhas_requisicoes/minhas_requisicoes_event.dart';
import 'package:almox_mobile/src/bloc/minhas_requisicoes/minhas_requisicoes_state.dart';
import 'package:almox_mobile/src/model/operador_model.dart';
import 'package:almox_mobile/src/pages/home/listagem_requisicoes_view.dart';
import 'package:almox_mobile/src/services/autenticacao_service.dart';
import 'package:almox_mobile/src/widgets/card_requisicao_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/requisicao_model.dart';
import '../../services/requisicao_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RequisicaoService requisicaoService = RequisicaoService();
  final AutenticacaoService _autenticacaoService = AutenticacaoService();

  List<RequisicaoModel> requisicoes = [];
  OperadorModel? _operadorLogado;

  @override
  void initState() {
    super.initState();
    _autenticacaoService.operadorLogado
        .then((value) => setState(() => _operadorLogado = value));
  }

  @override
  Widget build(BuildContext context) {
    final _botaoLogout = Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: InkWell(
          onTap: () => _autenticacaoService
              .logout()
              .then((_) => Navigator.pushNamed(context, '/login')),
          child: Icon(
            Icons.exit_to_app_rounded,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );

    final _botoesAcao = ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(
          width: 167,
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Icon(Icons.qr_code_outlined,
                          size: 35, color: Colors.grey.shade900)),
                  Text('Receber Requisição',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 167,
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamed('/operador'),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Icon(Icons.account_circle,
                              size: 35, color: Colors.grey.shade900)),
                      Text('Minha Conta',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800)),
                    ],
                  ),
                ),
              )),
        )
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                MinhasRequisicoesBloc()..add(CarregarMinhasRequisicoes())),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _operadorLogado == null
                                              ? 'Olá!'
                                              : 'Olá, ${_operadorLogado?.pessoa.nome}!',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 2),
                                        if (_operadorLogado != null)
                                          Text(
                                            _operadorLogado!.funcoes.reduce(
                                                (acc, curr) => '$acc, $curr'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.6)),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              _botaoLogout
                            ]),
                        SizedBox(height: 15),
                        SizedBox(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            child: _botoesAcao)
                      ],
                    )
                  ],
                ),
              ),
              if (_operadorLogado != null)
                ListagemRequisicoesView(operadorLogado: _operadorLogado!)
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            BlocBuilder<MinhasRequisicoesBloc, MinhasRequisicoesState>(
          builder: (context, state) => FloatingActionButton(
            elevation: 20,
            backgroundColor: Color.fromRGBO(200, 230, 201, 1),
            onPressed: () async {
              await Navigator.pushNamed(context, '/criarRequisicao');
              context
                  .read<MinhasRequisicoesBloc>()
                  .add(CarregarMinhasRequisicoes());
            },
            child: Icon(
              Icons.add,
              color: Color.fromRGBO(37, 96, 41, 1),
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
