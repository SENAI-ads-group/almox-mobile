import 'package:almox_mobile/src/services/operador_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../model/operador_model.dart';

class DropdownSearchAlmoxarife extends StatefulWidget {
  final ValueChanged<OperadorModel?>? onChanged;
  final FormFieldValidator<OperadorModel>? validator;
  final bool enabled;
  final String? idOperadorSelecionado;

  DropdownSearchAlmoxarife({
    Key? key,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.idOperadorSelecionado,
  }) : super(key: key);

  @override
  State<DropdownSearchAlmoxarife> createState() =>
      _DropdownSearchAlmoxarifeState();
}

class _DropdownSearchAlmoxarifeState extends State<DropdownSearchAlmoxarife> {
  final OperadorService operadorService = OperadorService();

  OperadorModel? _operadorSelecionado;

  void _mudarOperadorSelecionado(List<OperadorModel> operadores) {
    OperadorModel? _novoOperadorSelecionado;
    try {
      _novoOperadorSelecionado = widget.idOperadorSelecionado == null
          ? null
          : operadores.firstWhere(
              (ope) => ope.id == widget.idOperadorSelecionado,
            );
    } catch (e) {
      _novoOperadorSelecionado = null;
    }
    setState(() => _operadorSelecionado = _novoOperadorSelecionado);
  }

  @override
  void initState() {
    super.initState();
    operadorService.fetchOperadoresAlmoxarifes().then((value) {
      _mudarOperadorSelecionado(value);
    });
  }

  final _mensagemErro = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: Icon(Icons.clear_rounded, color: Colors.red, size: 50),
        ),
        Center(
          child: Text("erro ao carregar almoxarifes"),
        )
      ],
    ),
  );

  final _mensagemCarregando = Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      CircularProgressIndicator(),
      Text("carregando almoxarifes... aguarde...")
    ]),
  );

  final _mensagemNenhumItemEncontrado = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: Icon(
            Icons.warning,
            color: Colors.orangeAccent,
            size: 50,
          ),
        ),
        Center(
          child: Text("Nenhum almoxarife encontrado"),
        )
      ],
    ),
  );

  final _textFieldPesquisa = TextFieldProps(
    decoration: InputDecoration(
      labelText: "Pesquisar",
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.search),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<OperadorModel>(
      mode: Mode.DIALOG,
      selectedItem: _operadorSelecionado,
      enabled: widget.enabled,
      validator: widget.validator,
      onChanged: widget.onChanged,
      showClearButton: true,
      showSearchBox: true,
      searchFieldProps: _textFieldPesquisa,
      popupShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      itemAsString: (OperadorModel? ope) => ope?.pessoa.nome ?? "",
      onFind: (String? filter) async {
        final _operadoresFiltrados =
            await operadorService.fetchOperadoresAlmoxarifes(nome: filter);
        _mudarOperadorSelecionado(_operadoresFiltrados);

        return _operadoresFiltrados;
      },
      searchDelay: const Duration(seconds: 1),
      emptyBuilder: (BuildContext context, String? v) =>
          _mensagemNenhumItemEncontrado,
      loadingBuilder: (BuildContext context, String? v) => _mensagemCarregando,
      errorBuilder: (BuildContext context, String? v, dynamic d) =>
          _mensagemErro,
      dropdownSearchDecoration: InputDecoration(
        labelText: "Almoxarife",
        labelStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(),
      ),
    );
  }
}
