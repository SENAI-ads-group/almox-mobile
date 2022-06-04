import 'package:almox_mobile/src/services/departamento_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../model/departamento_model.dart';

class DropdownSearchDepartamento extends StatefulWidget {
  final ValueChanged<DepartamentoModel?>? onChanged;
  final FormFieldValidator<DepartamentoModel>? validator;
  final bool enabled;
  final String? idDepartamentoSelecionado;

  DropdownSearchDepartamento({
    Key? key,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.idDepartamentoSelecionado,
  }) : super(key: key);

  @override
  State<DropdownSearchDepartamento> createState() =>
      _DropdownSearchDepartamentoState();
}

class _DropdownSearchDepartamentoState
    extends State<DropdownSearchDepartamento> {
  final DepartamentoService departamentoService = DepartamentoService();

  DepartamentoModel? _departamentoSelecionado;

  void _mudarDepartamentoSelecionado(List<DepartamentoModel> departamentos) {
    DepartamentoModel? _novoOperadorSelecionado;
    try {
      _novoOperadorSelecionado = widget.idDepartamentoSelecionado == null
          ? null
          : departamentos.firstWhere(
              (ope) => ope.id == widget.idDepartamentoSelecionado,
            );
    } catch (e) {
      _novoOperadorSelecionado = null;
    }
    setState(() => _departamentoSelecionado = _novoOperadorSelecionado);
  }

  @override
  void initState() {
    super.initState();
    departamentoService.fetchDepartamentos().then((value) {
      if (mounted) _mudarDepartamentoSelecionado(value);
    });
  }

  final _mensagemErro = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: Icon(
            Icons.clear_rounded,
            color: Colors.red,
            size: 50,
          ),
        ),
        Center(
          child: Text("erro ao carregar departamentos"),
        )
      ],
    ),
  );

  final _mensagemCarregando = Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      CircularProgressIndicator(),
      Text("carregando... aguarde...")
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
          child: Text("Nenhum departamento encontrado"),
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
    return DropdownSearch<DepartamentoModel>(
      mode: Mode.DIALOG,
      selectedItem: _departamentoSelecionado,
      enabled: widget.enabled,
      validator: widget.validator,
      onChanged: widget.onChanged,
      showClearButton: true,
      showSearchBox: true,
      searchDelay: const Duration(seconds: 1),
      searchFieldProps: _textFieldPesquisa,
      popupShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      itemAsString: (DepartamentoModel? dpto) => dpto?.descricao ?? "",
      onFind: (String? filter) async =>
          await departamentoService.fetchDepartamentos(descricao: filter),
      emptyBuilder: (BuildContext context, String? v) =>
          _mensagemNenhumItemEncontrado,
      loadingBuilder: (BuildContext context, String? v) => _mensagemCarregando,
      errorBuilder: (BuildContext context, String? v, dynamic d) =>
          _mensagemErro,
      dropdownSearchDecoration: InputDecoration(
        labelText: "Departamento",
        labelStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(),
      ),
    );
  }
}
