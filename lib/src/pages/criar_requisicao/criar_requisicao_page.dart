import 'package:almox_mobile/src/model/grupo_model.dart';
import 'package:almox_mobile/src/model/item_requisicao_model.dart';
import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/services/departamento_service.dart';
import 'package:almox_mobile/src/services/operador_service.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/widgets/card_produto/botoes_adicionar_remover.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../almox_app_theme.dart';
import '../../light_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../model/departamento_model.dart';
import '../../model/operador_model.dart';

class CriarRequisicaoPage extends StatefulWidget {
  CriarRequisicaoPage({Key? key}) : super(key: key);

  @override
  State<CriarRequisicaoPage> createState() => _CriarRequisicaoPageState();
}

class _CriarRequisicaoPageState extends State<CriarRequisicaoPage> {
  final DepartamentoService _departamentoService = DepartamentoService();
  final OperadorService _operadorService = OperadorService();

  List<ItemRequisicaoModel> itensSelecionados = [];
  DepartamentoModel? _departamentoSelecionado;
  OperadorModel? _almoxarifeSelecionado;

  List<DepartamentoModel> _departamentosDisponiveis = [];
  List<OperadorModel> _almoxarifesDisponiveis = [];
  late Future<void> _dadosFormularioFuture;

  Future<void> fetchDadosFormulario() async {
    _departamentosDisponiveis = await _departamentoService.fetchDepartamentos();
    _almoxarifesDisponiveis = await _operadorService.fetchOperadoresAlmoxarifes();
  }

  _avisoInformeQuantidades() => AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        desc: 'Informe a quantidade dos produtos!',
        showCloseIcon: true,
        btnOkColor: Colors.green,
        btnOkOnPress: () {},
      ).show();

  Future<bool> _onWillPop(BuildContext context) {
    if (itensSelecionados.isNotEmpty) {
      bool existeItemSemQuantidade = itensSelecionados.any((item) => item.quantidade <= 0);

      if (existeItemSemQuantidade) {
        _avisoInformeQuantidades();
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  _pesquisarProdutos(BuildContext context) async {
    List<ProdutoModel>? produtosSelecionadosNaPesquisa = await Navigator.pushNamed(context, '/selecionarProdutos') as List<ProdutoModel>?;

    setState(() {
      itensSelecionados.addAll((produtosSelecionadosNaPesquisa ?? [])
          .where((ProdutoModel produto) => !itensSelecionados.any((i) => i.produto.id == produto.id))
          .map((ProdutoModel produto) => ItemRequisicaoModel(produto: produto, quantidade: 0)));
    });
  }

  void _decrementarQuantidadeItemRequisicao(int indexItemASerDecrementado) {
    setState(() {
      itensSelecionados.asMap().keys.toList().forEach((index) {
        if (index == indexItemASerDecrementado) {
          ItemRequisicaoModel item = itensSelecionados.elementAt(index);
          if (item.quantidade <= 0) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
              headerAnimationLoop: false,
              animType: AnimType.SCALE,
              desc: 'Remover Item!',
              showCloseIcon: false,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              btnOkText: 'Sim',
              btnOkColor: Colors.green,
              btnOkOnPress: () {
                setState(() {
                  itensSelecionados.removeAt(index);
                });
              },
              btnCancelText: 'Não',
              btnCancelColor: Colors.red,
              btnCancelOnPress: () {},
            ).show();
          } else {
            item.quantidade = item.quantidade - 1;
          }
        }
      });
    });
  }

  void _incrementarQuantidadeItemRequisicao(int indexItemASerIncrementado) {
    setState(() {
      itensSelecionados.asMap().keys.toList().forEach((index) {
        if (index == indexItemASerIncrementado) {
          ItemRequisicaoModel item = itensSelecionados.elementAt(index);
          item.quantidade = item.quantidade + 1;
        }
      });
    });
  }

  Card _cardItemRequisicao(ItemRequisicaoModel item) {
    int indexItem = itensSelecionados.indexOf(item);
    ItemRequisicaoModel itemRequisicao = itensSelecionados.elementAt(indexItem);
    TextEditingController quantidadeTextFieldController = TextEditingController(text: "${itemRequisicao.quantidade}");
    FocusNode focusNode = FocusNode();
    focusNode.addListener((() {
      if (focusNode.hasFocus) {
        quantidadeTextFieldController.selection = TextSelection(baseOffset: 0, extentOffset: quantidadeTextFieldController.text.length);
      }
    }));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
      child: ListTile(
        title: Text(item.produto.descricao),
        subtitle: Text(item.produto.grupo.descricao),
        trailing: BotoesAdicionarRemoverProduto(
            quantidadeTextField: TextField(
              focusNode: focusNode,
              controller: quantidadeTextFieldController,
              onSubmitted: (String valor) {
                setState(() {
                  itemRequisicao.quantidade = double.parse(valor);
                });
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            onRemoverPressed: () => _decrementarQuantidadeItemRequisicao(indexItem),
            onAdicionarPressed: () => _incrementarQuantidadeItemRequisicao(indexItem)),
      ),
    );
  }

  Widget _botoesInclusaoItem() => Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Incluir', style: TextStyle(fontSize: 18)),
              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))),
              onPressed: () async => await _pesquisarProdutos(context),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
              child: Icon(Icons.camera_alt),
              onPressed: () {},
            ),
          )
        ],
      );

  @override
  void initState() {
    super.initState();
    _departamentoService.fetchDepartamentos().then((value) => setState(() => _departamentosDisponiveis = value));
    _operadorService.fetchOperadoresAlmoxarifes().then((value) => setState(() => _almoxarifesDisponiveis = value));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> _campos = {
      "almoxarife": DropdownSearch<OperadorModel>(
        mode: Mode.BOTTOM_SHEET,
        items: _almoxarifesDisponiveis,
        dropdownSearchDecoration: InputDecoration(
          labelText: "Almoxarife",
          border: OutlineInputBorder(),
        ),
        popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        itemAsString: (OperadorModel? ope) => ope?.pessoa.nome ?? "",
        onFind: (String? filter) async {
          var almoxarifesEncontrados = await _operadorService.fetchOperadoresAlmoxarifes(nome: filter);
          setState(() => _almoxarifesDisponiveis = almoxarifesEncontrados);
          return almoxarifesEncontrados;
        },
        showSearchBox: true,
        searchDelay: const Duration(seconds: 1),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: "Pesquisar",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
        ),
        showClearButton: true,
        onChanged: (OperadorModel? value) => setState(() => _almoxarifeSelecionado = value),
        loadingBuilder: (BuildContext context, String? v) => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator(), Text("carregando almoxarifes... aguarde...")]),
        ),
        errorBuilder: (BuildContext context, String? v, dynamic d) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                  child: Icon(
                Icons.clear_rounded,
                color: Colors.red,
                size: 50,
              )),
              Center(
                child: Text("erro ao carregar almoxarifes"),
              )
            ],
          ),
        ),
      ),
      "departamento": DropdownSearch<DepartamentoModel>(
        mode: Mode.BOTTOM_SHEET,
        items: _departamentosDisponiveis,
        dropdownSearchDecoration: InputDecoration(
          labelText: "Departamento",
          border: OutlineInputBorder(),
        ),
        popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        itemAsString: (DepartamentoModel? dpto) => dpto?.descricao ?? "",
        onFind: (String? filter) async {
          var departamentosEncontrados = await _departamentoService.fetchDepartamentos(descricao: filter);
          setState(() => _departamentosDisponiveis = departamentosEncontrados);
          return departamentosEncontrados;
        },
        showSearchBox: true,
        searchDelay: const Duration(seconds: 1),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: "Pesquisar",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
        ),
        showClearButton: true,
        onChanged: (DepartamentoModel? value) => setState(() => _departamentoSelecionado = value),
        loadingBuilder: (BuildContext context, String? v) => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator(), Text("carregando departamentos... aguarde...")]),
        ),
        errorBuilder: (BuildContext context, String? v, dynamic d) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                  child: Icon(
                Icons.clear_rounded,
                color: Colors.red,
                size: 50,
              )),
              Center(
                child: Text("erro ao carregar departamentos"),
              )
            ],
          ),
        ),
      ),
    };

    final _formulario = Form(
        child: SingleChildScrollView(
      child: Column(
        children: _campos.values
            .map(
              (Widget campo) => Column(children: [
                campo,
                SizedBox(height: 25.0),
              ]),
            )
            .toList(),
      ),
    ));

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: AlmoxAppTheme.background,
        appBar: AppBar(
          title: Text("Criar Requisição"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const <Widget>[
                        Text(
                          'Cabeçalho',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                        ),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Informações da Requisição',
                            style: TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _formulario,
                    ]),
                  ),
                ),
                SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () async => await _pesquisarProdutos(context),
                    child: Center(
                      child: Text(
                        'Adicionar Produtos',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 5),
                Flexible(
                  child: ListView(
                    children: itensSelecionados.map((ItemRequisicaoModel item) => _cardItemRequisicao(item)).toList(),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(itensSelecionados.isEmpty ? Colors.grey : Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: itensSelecionados.isEmpty ? null : () {},
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
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
