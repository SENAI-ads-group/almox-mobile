import 'package:almox_mobile/src/pages/login/login_novoAcesso.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:almox_mobile/src/routes/routes.dart';
import 'package:almox_mobile/src/pages/login/login_page.dart';
import 'package:almox_mobile/src/pages/login/login_reset-password.dart';

//import 'reset-password.page.dart';
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _cpf = TextEditingController();

  String? _msgErroCpf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _cpf,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "CPF",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_box_outlined),
                  errorText: _msgErroCpf,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(),
                          ),
                        );
                      },
                      child: const Text("Esqueceu a senha?"))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent]),
                ),
                child: MaterialButton(
                  onPressed: () {
                    String cpf = _cpf.text;
                    if (GetUtils.isCpf(cpf)) {
                      print('CPF válido');
                    } else {
                      setState(() {
                        _msgErroCpf = 'Cpf Inválido';
                      });

                      print('CPF inválido');
                      showAlertDialog1(BuildContext context) {
                        // configura o button
                        Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {},
                        );
                      }
                    }
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 30,
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Novo por aqui?",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NovoAcesso(),
                          ),
                        );
                      },
                      child: const Text("Solicite acesso ao App"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
