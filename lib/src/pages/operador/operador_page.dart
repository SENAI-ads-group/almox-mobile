import 'package:almox_mobile/src/model/operador_model.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../almox_app_theme.dart';
import '../../services/autenticacao_service.dart';
import '../../widgets/container_carregando_widget.dart';

class OperadorPage extends StatefulWidget {
  OperadorPage({Key? key}) : super(key: key);

  @override
  State<OperadorPage> createState() => _OperadorPageState();
}

class _OperadorPageState extends State<OperadorPage> {
  final AutenticacaoService _autenticacaoService = AutenticacaoService();
  bool _carregando = false;

  OperadorModel? _operadorLogado;

  @override
  void initState() {
    super.initState();
    _autenticacaoService.operadorLogado
        .then((value) => setState(() => _operadorLogado = value));
  }

  _botaoLogout() => SizedBox(
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 15,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            'Sair',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () => _autenticacaoService
              .logout()
              .then((_) => Navigator.pushNamed(context, '/login')),
        ),
      );

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Dados da Conta'),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            AppBar().preferredSize.height + 2));
  }

  Map<String, Widget> _campos() => {
        if (_operadorLogado != null)
          "nome": TextFormField(
              initialValue: _operadorLogado!.pessoa.nome,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                  enabled: false,
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ))),
        if (_operadorLogado != null)
          "cpf": TextFormField(
            initialValue:
                UtilBrasilFields.obterCpf(_operadorLogado!.pessoa.cpf),
            decoration: const InputDecoration(
              enabled: false,
              labelText: "CPF",
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ),
        if (_operadorLogado != null)
          "email": TextFormField(
              initialValue: _operadorLogado!.pessoa.email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                  enabled: false,
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ))),
        if (_operadorLogado != null)
          "funcoes": TextFormField(
            initialValue:
                _operadorLogado!.funcoes.reduce((acc, curr) => '$acc, $curr'),
            minLines: 1,
            maxLines: 2,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Funções',
              enabled: false,
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          )
      };

  _cardFormulario() => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    children: _campos()
                        .values
                        .toList()
                        .asMap()
                        .map(
                          (index, campo) => MapEntry(
                            index,
                            index == _campos().values.length - 1
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

  _body() => ListView(
        children: [
          _cardFormulario(),
          SizedBox(height: MediaQuery.of(context).size.height - 600),
          _botaoLogout(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlmoxAppTheme.background,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: _carregando ? ContainerCarregando(child: _body()) : _body(),
      ),
    );
  }
}
