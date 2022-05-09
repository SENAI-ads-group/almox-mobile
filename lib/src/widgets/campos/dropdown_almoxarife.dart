import 'package:almox_mobile/src/services/operador_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../model/operador_model.dart';

class DropdownSearchAlmoxarife extends StatelessWidget {
  final OperadorService operadorService = OperadorService();
  final ValueChanged<OperadorModel?>? onChanged;
  final FormFieldValidator<OperadorModel>? validator;

  DropdownSearchAlmoxarife({
    Key? key,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<OperadorModel>(
      mode: Mode.DIALOG,
      validator: validator,
      dropdownSearchDecoration: InputDecoration(
        labelText: "Almoxarife",
        labelStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(),
      ),
      popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      itemAsString: (OperadorModel? ope) => ope?.pessoa.nome ?? "",
      onFind: (String? filter) async => await operadorService.fetchOperadoresAlmoxarifes(nome: filter),
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
              child: Text("Nenhum almoxarife encontrado"),
            )
          ],
        ),
      ),
      loadingBuilder: (BuildContext context, String? v) => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: const [CircularProgressIndicator(), Text("carregando almoxarifes... aguarde...")]),
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
    );
  }
}
