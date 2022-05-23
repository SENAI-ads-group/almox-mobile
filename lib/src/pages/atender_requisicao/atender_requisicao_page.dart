import 'dart:ffi';

import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/model/status_requisicao.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:almox_mobile/src/widgets/campos/dropdown_almoxarife.dart';
import 'package:almox_mobile/src/widgets/card_item_requisicao/card_item_requisicao_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../../almox_app_theme.dart';

import '../../model/departamento_model.dart';
import '../../model/operador_model.dart';
import '../../services/autenticacao_service.dart';
import '../../widgets/campos/dropdown_departamento.dart';
import '../../widgets/container_carregando_widget.dart';

class AtenderRequisicaoPage extends StatefulWidget {
  AtenderRequisicaoPage({Key? key}) : super(key: key);

  @override
  State<AtenderRequisicaoPage> createState() => _AtenderRequisicaoPageState();
}

class _AtenderRequisicaoPageState extends State<AtenderRequisicaoPage> {
  final _formKey = GlobalKey<FormState>();
  final requisicaoService = RequisicaoService();
  final AutenticacaoService _autenticacaoService = AutenticacaoService();

  List<ItemRequisicaoModel> itensSelecionados = [];
  DepartamentoModel? _departamentoSelecionado;
  OperadorModel? _almoxarifeSelecionado;
  bool _carregando = false;
  OperadorModel? _operadorLogado;

  bool _existeItemSemQuantidade() => itensSelecionados.isEmpty || itensSelecionados.any((item) => item.quantidade <= 0);

  @override
  void initState() {
    super.initState();
    _autenticacaoService.operadorLogado
        .then((value) => setState(() => _operadorLogado = value));
  }

  Future<bool> _onWillPop(BuildContext context) {
    if (itensSelecionados.isNotEmpty) {
      // lógica de salvar requisição localmente
    }
    return Future.value(true);
  }

  void _pesquisarProdutos(BuildContext context) async {
    List<ProdutoModel>? produtosSelecionadosNaPesquisa = await Navigator.pushNamed(context, '/selecionarProdutos') as List<ProdutoModel>?;

    setState(() {
      itensSelecionados.addAll((produtosSelecionadosNaPesquisa ?? [])
          .where((ProdutoModel produto) => !itensSelecionados.any((i) => i.produto.id == produto.id))
          .map((ProdutoModel produto) => ItemRequisicaoModel.fromProdutoModel(produto, 0)));
    });
  }

  CardItemRequisicao _cardItemRequisicao(ItemRequisicaoModel item) {
    int indexItem = itensSelecionados.indexOf(item);
    ItemRequisicaoModel itemRequisicao = itensSelecionados.elementAt(indexItem);

    return CardItemRequisicao(
      indexItem: indexItem,
      itemRequisicao: itemRequisicao,
      onQuantidadeChanged: (double valor) => setState(() => itemRequisicao.quantidade = valor),
      onAdicionarPressed: () => setState(() => itemRequisicao.quantidade += 1),
      onRemoverPressed: () async {
        if (itemRequisicao.quantidade <= 0) {
          final resposta = await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Itens'),
              content: Text('Tem certeza que deseja remover este item da lista?'),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => Navigator.pop(context, 'Não'),
                  child: const Text('Não'),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () => Navigator.pop(context, 'Sim'),
                  child: const Text('Sim'),
                ),
              ],
            ),
          );
          if (resposta == 'Sim') setState(() => itensSelecionados.removeAt(indexItem));
        } else {
          setState(() => itemRequisicao.quantidade -= 1);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as RequisicaoModel;
    final RequisicaoModel requisicaoModel = args;
    itensSelecionados = requisicaoModel.itens;
    bool _statusSpeedDial = false;

    setState(() {
      if (requisicaoModel.status == StatusRequisicao.CANCELADA ||
          requisicaoModel.status == StatusRequisicao.ENTREGUE) {
        _statusSpeedDial = false;
      } else {
        _statusSpeedDial = true;
      }
    });

    final Map<String, Widget> _campos = {
      "requisitante": TextFormField(
          initialValue: requisicaoModel.requisitante.pessoa.nome,
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
        idOperadorSelecionado: requisicaoModel.almoxarife.id,
        enabled: false,
        onChanged: (OperadorModel? value) => setState(() => _almoxarifeSelecionado = value),
        validator: (OperadorModel? value) {
          if (value == null) return "Campo obrigatório";
          return null;
        },
      ),
      "departamento": DropdownSearchDepartamento(
        enabled: false,
        idDepartamentoSelecionado: requisicaoModel.departamento.id,
        onChanged: (DepartamentoModel? value) => setState(() => _departamentoSelecionado = value),
        validator: (DepartamentoModel? value) {
          if (value == null) return "Campo obrigatório";
          return null;
        },
      ),
      "dataRequisicao": TextFormField(
          initialValue: DateFormat("dd 'de' MMMM 'de' y", "pt_BR").format(requisicaoModel.dataRequisicao),
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Data Requisição',
              enabled: false,
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ))),
      "status": TextFormField(
          initialValue: requisicaoModel.status.descricao,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Status',
              enabled: false,
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )))
    };

    final _cardFormulario = Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text('Cabeçalho', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
              Text('Informações da Requisição', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
            ]),
            SizedBox(height: 20),
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
                                  children: [campo], // campo sem margem inferior
                                )
                              : Column(
                                  children: [campo, SizedBox(height: 25)], // campo com margem inferior
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
    );

    final _botaoAdicionarProduto = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          onPressed: () => _pesquisarProdutos(context),
          child: Center(
            child: Text(
              'Listar produtos',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
        ),
      ],
    );

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
              'Você não Possui Produtos Adicionados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text("Adicione produtos para continuar", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );

    final _body = ListView(
      children: [
        _cardFormulario,
        SizedBox(height: 10),
        SizedBox(
          height: 175,
          child: itensSelecionados.isEmpty
              ? _cardInformativoSemProdutosAdicionados
              : ListView(
                  children: itensSelecionados.map(_cardItemRequisicao).toList(),
                ),
        ),
        SizedBox(height: 10),
        Align(alignment: Alignment.bottomCenter, child: SizedBox(height: 45))
      ],
    );

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: AlmoxAppTheme.background,
        appBar: AppBar(title: Text("Atender Requisição")),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _carregando ? ContainerCarregando(child: _body) : _body,
        ),
        floatingActionButton: SpeedDial(
          elevation: 20,
          activeLabel: _body,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          visible: _statusSpeedDial,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.ads_click_outlined, color: Colors.white),
              backgroundColor: Colors.yellow,
              onTap: () => setState(() {
                if (requisicaoModel.status != StatusRequisicao.AGUARDANDO_ATENDIMENTO) {
                } else {
                  requisicaoService.atenderRequisicao(requisicaoModel.id);
                }
              }),
              label: 'ATENDER',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.yellow,
            ),
            SpeedDialChild(
              child: Icon(Icons.delivery_dining_sharp, color: Colors.white),
              backgroundColor: Colors.green,
              onTap: () => setState(() {
                if (requisicaoModel.status != StatusRequisicao.EM_ATENDIMENTO) {
                } else {
                  requisicaoService.entregarRequisicao(requisicaoModel.id);
                }
              }),
              label: 'ENTREGAR',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.green,
            ),
            SpeedDialChild(
              child: Icon(Icons.cancel_outlined, color: Colors.white),
              backgroundColor: Colors.red,
              onTap: () => setState(() {
                if (requisicaoModel.status != StatusRequisicao.CANCELADA) {
                } else {
                  requisicaoService.cancelarRequisicao(requisicaoModel.id);
                }
              }),
              label: 'CANCELAR',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
