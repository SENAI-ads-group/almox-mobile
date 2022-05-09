import 'package:almox_mobile/src/services/departamento_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../model/departamento_model.dart';

class DropdownSearchDepartamento extends StatelessWidget {
  final DepartamentoService departamentoService = DepartamentoService();
  final ValueChanged<DepartamentoModel?>? onChanged;
  final FormFieldValidator<DepartamentoModel>? validator;

  DropdownSearchDepartamento({
    Key? key,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<DepartamentoModel>(
      mode: Mode.DIALOG,
      validator: validator,
      dropdownSearchDecoration: InputDecoration(
        labelText: "Departamento",
        labelStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(),
      ),
      popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      itemAsString: (DepartamentoModel? dpto) => dpto?.descricao ?? "",
      onFind: (String? filter) async => await departamentoService.fetchDepartamentos(descricao: filter),
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
      onChanged: onChanged,
      emptyBuilder: (BuildContext context, String? v) => Center(
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
      ),
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
              ),
            ),
            Center(
              child: Text("erro ao carregar departamentos"),
            )
          ],
        ),
      ),
    );
  }
}
