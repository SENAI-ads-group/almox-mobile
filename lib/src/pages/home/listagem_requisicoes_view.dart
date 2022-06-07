import 'package:almox_mobile/src/bloc/minhas_requisicoes/minhas_requisicoes_event.dart';
import 'package:almox_mobile/src/model/operador_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/minhas_requisicoes/minhas_requisicoes_boc.dart';
import '../../bloc/minhas_requisicoes/minhas_requisicoes_state.dart';
import '../../widgets/card_requisicao_widget.dart';

class ListagemRequisicoesView extends StatelessWidget {
  final OperadorModel operadorLogado;
  const ListagemRequisicoesView({Key? key, required this.operadorLogado})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MinhasRequisicoesBloc, MinhasRequisicoesState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          maxChildSize: .87,
          initialChildSize: .69,
          minChildSize: .69,
          builder: (context, scrollController) {
            return Card(
              elevation: 10,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Minhas Requisições',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black87),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context
                              .read<MinhasRequisicoesBloc>()
                              .add(CarregarMinhasRequisicoes()),
                          icon: Icon(
                            Icons.sync,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(height: 10),
                    if (MinhasRequisicoesStatus.success == state.status)
                      if (state.minhasRequisicoes.isNotEmpty)
                        ...state.minhasRequisicoes
                            .map(
                              (r) => CardRequisicao(
                                requisicao: r,
                                operadorLogado: operadorLogado,
                                onTap: () async {
                                  await Navigator.of(context).pushNamed(
                                      '/atenderRequisicao',
                                      arguments: r);
                                  context
                                      .read<MinhasRequisicoesBloc>()
                                      .add(CarregarMinhasRequisicoes());
                                },
                              ),
                            )
                            .toList()
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 100),
                            Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Icon(
                                  Icons.warning,
                                  color: Colors.orangeAccent,
                                  size: 85,
                                ),
                              ),
                            ),
                            Text(
                              'Você ainda não tem nenhuma requisição',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade700,
                              ),
                              onPressed: () => context
                                  .read<MinhasRequisicoesBloc>()
                                  .add(CarregarMinhasRequisicoes()),
                              child: Text('Recarregar'),
                            ),
                          ],
                        )
                    else if (MinhasRequisicoesStatus.loading == state.status)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          SizedBox(height: 100),
                          Center(
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Carregando... Aguarde',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    else if (MinhasRequisicoesStatus.failure == state.status)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(height: 100),
                          Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Icon(
                                Icons.clear_rounded,
                                color: Colors.red,
                                size: 85,
                              ),
                            ),
                          ),
                          Text(
                            'Não foi possível carregar as requisições',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade700,
                            ),
                            onPressed: () => context
                                .read<MinhasRequisicoesBloc>()
                                .add(CarregarMinhasRequisicoes()),
                            child: Text('Tentar Novamente'),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
