import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:almox_mobile/src/pages/login/login_reset-password.dart';
import 'package:validatorless/validatorless.dart';
import 'package:almox_mobile/src/validators/validators.dart';

//import 'reset-password.page.dart';
class NovoAcesso extends StatefulWidget {
  const NovoAcesso({Key? key}) : super(key: key);

  @override
  State<NovoAcesso> createState() => _NovoAcessoState();
}

class _NovoAcessoState extends State<NovoAcesso> {
  final TextEditingController _cpf = TextEditingController();

//  final TextEditingController _cpf = TextEditingController();
  final _nameEC = TextEditingController();
  final _cpfEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _msgErroCpf;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 1,
          left: 40,
          right: 40,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 10,
                height: 10,
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                "Novo por aqui?",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Preecha os campos abaixo e aguarde autorização de acesso.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _nameEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Preencha o campo nome'),
                  Validatorless.min(8, 'Preencha nome e sobrenome')
                ]),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Nome Completo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _cpfEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Preencha o campo CPF'),
                  Validatorless.cpf('verifique cpf'),
                ]),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Cpf",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.article_outlined),
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  errorText: _msgErroCpf,
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Preencha o campo email'),
                  Validatorless.email('Verifique seu email'),
                ]),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _passwordEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Preencha o campo Senha'),
                  Validatorless.min(6, 'Senha de possuir pelo menos 6 dígitos'),
                ]),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _confirmPasswordEC,
                validator: Validatorless.multiple([
                  Validatorless.required('confirmar senha obrigatoria'),
                  Validatorless.min(6, 'pelo menos 6 caracteres'),
                  Validators.compare(
                      _passwordEC, 'Senha não confere')
                ]),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Confirme sua Senha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blue]),
                ),
                child: MaterialButton(
                  onPressed: () {
                    var formValid = _formKey.currentState?.validate() ?? false;
                    if (formValid) {}
                  },
                  child: const Text(
                    "Enviar",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
