import 'package:almox_mobile/src/pages/home/home_controller.dart';
import 'package:almox_mobile/src/pages/home/home_page.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_operador_widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OperadorPage extends PaginaNavegacao {
  OperadorPage() : super(child: _OperadorPage(), botaoNavegacao: BotaoNavegacaoOperador());
}

class _OperadorPage extends StatelessWidget {
  final HomeController homeController = HomeController();
  _OperadorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeController.indexPaginaChangeNotifier.addListener(() {
      if (homeController.indexPaginaAtual == 1) {
        homeController.setBotaoAcao(floatingActionButton: null);
      }
    });

    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OPERADOR',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (text) {},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (text) {},
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
                onChanged: (text) {},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (text) {},
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              RaisedButton(
                onPressed: () {},
                child: Text('SAIR'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
