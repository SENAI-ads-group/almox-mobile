import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:almox_mobile/src/widgets/campos/dropdown_almoxarife.dart';
import 'package:almox_mobile/src/widgets/card_item_requisicao/card_item_requisicao_widget.dart';
import 'package:flutter/material.dart';

import '../../almox_app_theme.dart';

import '../../model/departamento_model.dart';
import '../../model/operador_model.dart';
import '../../widgets/campos/dropdown_departamento.dart';
import '../../widgets/container_carregando_widget.dart';

class CriarRequisicaoPage extends StatefulWidget {
  CriarRequisicaoPage({Key? key}) : super(key: key);

  @override
  State<CriarRequisicaoPage> createState() => _CriarRequisicaoPageState();
}

class _CriarRequisicaoPageState extends State<CriarRequisicaoPage> {
  final _formKey = GlobalKey<FormState>();
  final requisicaoService = RequisicaoService();

  List<ItemRequisicaoModel> itensSelecionados = [];
  DepartamentoModel? _departamentoSelecionado;
  OperadorModel? _almoxarifeSelecionado;
  bool _carregando = false;

  bool _existeItemSemQuantidade() =>
      itensSelecionados.isEmpty ||
      itensSelecionados.any((item) => item.quantidade <= 0);

  Future<bool> _onWillPop(BuildContext context) {
    if (itensSelecionados.isNotEmpty) {
      // lógica de salvar requisição localmente
    }
    return Future.value(true);
  }

  void _pesquisarProdutos(BuildContext context) async {
    List<ProdutoModel>? produtosSelecionadosNaPesquisa =
        await Navigator.pushNamed(context, '/selecionarProdutos')
            as List<ProdutoModel>?;

    setState(() {
      itensSelecionados.addAll((produtosSelecionadosNaPesquisa ?? [])
          .where((ProdutoModel produto) =>
              !itensSelecionados.any((i) => i.produto.id == produto.id))
          .map((ProdutoModel produto) =>
              ItemRequisicaoModel.fromProdutoModel(produto, 0)));
    });
  }

  CardItemRequisicao _cardItemRequisicao(ItemRequisicaoModel item) {
    int indexItem = itensSelecionados.indexOf(item);
    ItemRequisicaoModel itemRequisicao = itensSelecionados.elementAt(indexItem);

    return CardItemRequisicao(
      itemRequisicao: itemRequisicao,
      onQuantidadeChanged: (double valor) =>
          setState(() => itemRequisicao.quantidade = valor),
      onAdicionarPressed: () => setState(() => itemRequisicao.quantidade += 1),
      onRemoverPressed: () async {
        if (itemRequisicao.quantidade <= 0) {
          final resposta = await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Itens'),
              content:
                  Text('Tem certeza que deseja remover este item da lista?'),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => Navigator.pop(context, 'Não'),
                  child: const Text('Não'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () => Navigator.pop(context, 'Sim'),
                  child: const Text('Sim'),
                ),
              ],
            ),
          );
          if (resposta == 'Sim')
            setState(() => itensSelecionados.removeAt(indexItem));
        } else {
          setState(() => itemRequisicao.quantidade -= 1);
        }
      },
    );
  }

  void _onSalvar() async {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    final requestCriarRequisicao = CriarRequisicao(
      idOperadorAlmoxarife: _almoxarifeSelecionado!.id,
      idDepartamento: _departamentoSelecionado!.id,
      itens: itensSelecionados
          .map(
            (ItemRequisicaoModel item) => CriarRequisicaoItem(
              idProduto: item.produto.id,
              quantidade: item.quantidade,
            ),
          )
          .toList(),
    );

    final _snackbarSucesso = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Requisição criada com sucesso'),
          Icon(Icons.check, color: Colors.white),
        ],
      ),
      duration: Duration(milliseconds: 350),
      backgroundColor: Colors.green,
    );

    final _snackbarErro = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Não foi possível criar a requisição'),
          Icon(Icons.error)
        ],
      ),
      backgroundColor: Colors.red,
    );

    if (!_carregando) {
      setState(() => _carregando = true);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        await requisicaoService.criarRequisicao(requestCriarRequisicao);

        ScaffoldMessenger.of(context).showSnackBar(_snackbarSucesso);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(_snackbarErro);
      } finally {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> _campos = {
      "almoxarife": DropdownSearchAlmoxarife(
        onChanged: (OperadorModel? value) =>
            setState(() => _almoxarifeSelecionado = value),
        validator: (OperadorModel? value) {
          if (value == null) return "Campo obrigatório";
          return null;
        },
      ),
      "departamento": DropdownSearchDepartamento(
        onChanged: (DepartamentoModel? value) =>
            setState(() => _departamentoSelecionado = value),
        validator: (DepartamentoModel? value) {
          if (value == null) return "Campo obrigatório";
          return null;
        },
      )
    };

    final _cardFormulario = Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Cabeçalho',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ]),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
              Text('Informações da Requisição',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400)),
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
              'Adicionar Produtos',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
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
            child: Text("Adicione produtos para continuar",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );

    final _botaoSalvar = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            _existeItemSemQuantidade() ? Colors.grey : Colors.green),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: _existeItemSemQuantidade() ? null : _onSalvar,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.save),
            SizedBox(width: 5),
            Text(
              'Salvar',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            )
          ],
        ),
      ),
    );

    final _body = ListView(
      children: [
        _cardFormulario,
        SizedBox(height: 10),
        _botaoAdicionarProduto,
        SizedBox(
          height: 175,
          child: itensSelecionados.isEmpty
              ? _cardInformativoSemProdutosAdicionados
              : ListView(
                  children: itensSelecionados.map(_cardItemRequisicao).toList(),
                ),
        ),
        SizedBox(height: 10),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(height: 45, child: _botaoSalvar))
      ],
    );

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: AlmoxAppTheme.background,
        appBar: AppBar(title: Text("Criar Requisição")),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _carregando ? ContainerCarregando(child: _body) : _body,
        ),
      ),
    );
  }
}
