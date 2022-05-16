import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OperadorPage extends StatefulWidget {
  OperadorPage({Key? key}) : super(key: key);

  @override
  State<OperadorPage> createState() => _OperadorPageState();
}

class _OperadorPageState extends State<OperadorPage> {
  @override
  void initState() {
    super.initState();
    //homeController.indexPaginaChangeNotifier.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
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
