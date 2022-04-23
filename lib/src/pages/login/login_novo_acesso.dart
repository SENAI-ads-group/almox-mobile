
// ignore_for_file: deprecated_member_use

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:almox_mobile/src/pages/login/login_reset-password.dart';

//import 'reset-password.page.dart';
class NovoAcesso extends StatefulWidget {
  const NovoAcesso({Key? key}) : super(key: key);

  
  @override
  State<NovoAcesso> createState() => _NovoAcessoState();
}

class _NovoAcessoState extends State<NovoAcesso> {
    final TextEditingController _cpf = TextEditingController();

  String? _msgErroCpf;
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
          top: 10,
          left: 40,
          right: 40,
        
        ),
        color: Colors.white,
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
                fontSize: 32,
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
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
              TextFormField(
               
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
              height: 10,
            ),
               TextFormField(
                controller: _cpf,
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
                ),style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            SizedBox(
              height: 10,
            ),
             TextFormField(
               
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
              height: 10,
            ),
            TextFormField(
               
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
              height: 10,
            ),
            TextFormField(
               
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Repita sua Senha",
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
                  "Enviar",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}