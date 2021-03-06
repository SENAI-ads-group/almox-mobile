import 'package:almox_mobile/src/bloc/atendimento_requisicao/atendimento_requisicao_bloc.dart';
import 'package:almox_mobile/src/bloc/atendimento_requisicao/atendimento_requisicao_event.dart';
import 'package:almox_mobile/src/bloc/atendimento_requisicao/atendimento_requisicao_state.dart';
import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/model/status_requisicao.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:almox_mobile/src/widgets/campos/dropdown_almoxarife.dart';
import 'package:almox_mobile/src/widgets/card_item_requisicao/card_item_requisicao_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../almox_app_theme.dart';

import '../../model/departamento_model.dart';
import '../../model/operador_model.dart';
import '../../widgets/campos/dropdown_departamento.dart';
import '../../widgets/card_requisicao_widget.dart';

class AtenderRequisicaoPage extends StatelessWidget {
  const AtenderRequisicaoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requisicao =
        ModalRoute.of(context)!.settings.arguments as RequisicaoModel;
    return BlocProvider(
      create: (_) =>
          AtendimentoRequisicaoBloc(requisicao)..add(CarregarAtendimento()),
      child: AtenderRequisicaoView(),
    );
  }
}

class AtenderRequisicaoView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final requisicaoService = RequisicaoService();

  AtenderRequisicaoView({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final _cardInformativoSemProdutosAdicionados = Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Icon(
              Icons.info,
              color: Colors.blue,
              size: 50,
            ),
          ),
          Center(
            child: Text(
              'Voc?? n??o Possui Produtos Adicionados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text("Adicione produtos para continuar",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child:
          BlocListener<AtendimentoRequisicaoBloc, AtendimentoRequisicaoState>(
        listener: (context, state) => {},
        child:
            BlocBuilder<AtendimentoRequisicaoBloc, AtendimentoRequisicaoState>(
          buildWhen: (previous, current) =>
              previous != current ||
              previous.requisicao.itens.length !=
                  current.requisicao.itens.length ||
              current.status != previous.status,
          builder: (context, state) {
            if (state.exibirQrcode) {
              return Scaffold(
                appBar: AppBar(title: Text('Confirma????o de recebimento')),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Solicite a confirma????o de recebimento para ${state.requisicao.requisitante.pessoa.nome}. ',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    QrImage(data: state.requisicao.codigoConfirmacao!),
                    Text(
                      state.requisicao.codigoConfirmacao!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black87),
                    ),
                  ]),
                ),
              );
            }

            final Map<String, Widget> _campos = {
              "requisitante": TextFormField(
                  initialValue: state.requisicao.requisitante.pessoa.nome,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Requisitante',
                      enabled: false,
                      labelStyle: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ))),
              "almoxarife": DropdownSearchAlmoxarife(
                idOperadorSelecionado: state.requisicao.almoxarife.id,
                enabled: false,
                onChanged: (OperadorModel? value) {},
                validator: (OperadorModel? value) {
                  if (value == null) return "Campo obrigat??rio";
                  return null;
                },
              ),
              "departamento": DropdownSearchDepartamento(
                enabled: false,
                idDepartamentoSelecionado: state.requisicao.departamento.id,
                onChanged: (DepartamentoModel? value) {},
                validator: (DepartamentoModel? value) {
                  if (value == null) return "Campo obrigat??rio";
                  return null;
                },
              ),
              "dataRequisicao": TextFormField(
                  initialValue: DateFormat("dd 'de' MMMM 'de' y", "pt_BR")
                      .format(state.requisicao.dataRequisicao),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data Requisi????o',
                      enabled: false,
                      labelStyle: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ))),
              "status": TextFormField(
                initialValue: state.status.descricao,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status',
                  enabled: false,
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              )
            };

            final _cardFormulario = Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        state.requisicao.requisitante.pessoa.nome,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(state.requisicao.departamento.descricao),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SingleChildScrollView(
                            child: Column(
                              children: _campos.values
                                  .toList()
                                  .asMap()
                                  .map(
                                    (index, campo) => MapEntry(
                                      index,
                                      index == _campos.values.length - 1
                                          ? Column(
                                              children: [
                                                campo
                                              ], // campo sem margem inferior
                                            )
                                          : Column(
                                              children: [
                                                campo,
                                                SizedBox(height: 25)
                                              ], // campo com margem inferior
                                            ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]));

            final atendimentoRequisicaoBloc =
                context.read<AtendimentoRequisicaoBloc>();

            return Scaffold(
              backgroundColor: AlmoxAppTheme.background,
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: state.podeCancelar
                          ? () async {
                              final resposta = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Cancelamento'),
                                  content: Text(
                                      'Tem certeza que deseja cancelar esta requisi????o?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () =>
                                          Navigator.pop(context, 'N??o'),
                                      child: const Text('N??o'),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green)),
                                      onPressed: () =>
                                          Navigator.pop(context, 'Sim'),
                                      child: const Text('Sim'),
                                    ),
                                  ],
                                ),
                              );
                              if (resposta == 'Sim') {
                                atendimentoRequisicaoBloc
                                    .add(CancelarRequisicao());
                              }
                            }
                          : null,
                      icon: Icon(Icons.block)),
                  IconButton(
                    onPressed: state.podeEntregar
                        ? () {
                            atendimentoRequisicaoBloc.add(EntregarRequisicao());
                            atendimentoRequisicaoBloc.add(SetIndex(1));
                          }
                        : null,
                    icon: Icon(Icons.check),
                  ),
                  IconButton(
                    onPressed: state.podeAtender
                        ? () {
                            atendimentoRequisicaoBloc.add(IniciarAtendimento());
                            atendimentoRequisicaoBloc.add(SetIndex(1));
                          }
                        : null,
                    icon: Icon(Icons.start_outlined),
                  ),
                  IconButton(
                    onPressed: state.podeSalvar ? () {} : null,
                    icon: Icon(Icons.save),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: IndexedStack(
                      index: state.index,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: _cardFormulario,
                        ),
                        Column(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    ),
                                    onPressed: state.podeEditarItens
                                        ? () async {
                                            List<ProdutoModel>?
                                                produtosSelecionadosNaPesquisa =
                                                await Navigator.pushNamed(
                                                        context,
                                                        '/selecionarProdutos')
                                                    as List<ProdutoModel>?;

                                            context
                                                .read<
                                                    AtendimentoRequisicaoBloc>()
                                                .add(
                                                  AdicionarProdutos(
                                                      produtosSelecionadosNaPesquisa ??
                                                          []),
                                                );
                                          }
                                        : null,
                                    child: Center(
                                      child: Text(
                                        'Adicionar Produtos',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: state.requisicao.itens.isEmpty
                                  ? _cardInformativoSemProdutosAdicionados
                                  : ListView(
                                      children: state.requisicao.itens
                                          .map((itemRequisicao) {
                                        int indexItem = state.requisicao.itens
                                            .indexOf(itemRequisicao);

                                        return CardItemRequisicao(
                                          enabled: state.podeEditarItens,
                                          itemRequisicao: itemRequisicao,
                                          onQuantidadeChanged: (double valor) =>
                                              context
                                                  .read<
                                                      AtendimentoRequisicaoBloc>()
                                                  .add(SetQuantidadeItem(
                                                      indexItem, valor)),
                                          onAdicionarPressed: () => context
                                              .read<AtendimentoRequisicaoBloc>()
                                              .add(AdicionarQuantidadeItem(
                                                  indexItem)),
                                          onRemoverPressed: () async {
                                            if (itemRequisicao.quantidade <=
                                                0) {
                                              final resposta =
                                                  await showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text('Itens'),
                                                  content: Text(
                                                      'Tem certeza que deseja remover este item da lista?'),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .red)),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'N??o'),
                                                      child: const Text('N??o'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green)),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'Sim'),
                                                      child: const Text('Sim'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (resposta == 'Sim') {
                                                context
                                                    .read<
                                                        AtendimentoRequisicaoBloc>()
                                                    .add(
                                                        RemoverItem(indexItem));
                                              }
                                            } else {
                                              context
                                                  .read<
                                                      AtendimentoRequisicaoBloc>()
                                                  .add(
                                                    RemoverQuantidadeItem(
                                                        indexItem),
                                                  );
                                            }
                                          },
                                        );
                                      }).toList(),
                                    ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (state.carregando)
                    Container(
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 300.0,
                        height: 200.0,
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  value: null,
                                  strokeWidth: 7.0,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25.0),
                              child: Center(
                                child: Text(
                                  "carregando... aguarde...",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.index,
                onTap: state.carregando
                    ? null
                    : (i) => context
                        .read<AtendimentoRequisicaoBloc>()
                        .add(SetIndex(i)),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.info),
                    label: 'Dados',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Itens',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
