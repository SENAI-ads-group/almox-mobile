import 'package:almox_mobile/src/services/autenticacao_service.dart';
import 'package:almox_mobile/src/widgets/container_carregando_widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:almox_mobile/src/pages/login/login_reset-password.dart';
import 'package:almox_mobile/src/pages/login/login_novo_acesso.dart';
import 'package:validatorless/validatorless.dart';

//import 'reset-password.page.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AutenticacaoService _autenticacaoService = AutenticacaoService();

  final _cpfEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _carregando = false;
  bool _verificouToken = false;

  @override
  void dispose() {
    _cpfEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  _onRealizarLogin() async {
    final formularioValido = _formKey.currentState?.validate() ?? false;

    final _snackbarSucesso = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Login realizado com suceso!'),
          Icon(Icons.check, color: Colors.white),
        ],
      ),
      duration: Duration(milliseconds: 350),
      backgroundColor: Colors.green,
    );

    final _snackbarLoginInvalido = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [Text('Usuário ou senha inválido'), Icon(Icons.error)],
      ),
      backgroundColor: Colors.red,
    );

    final _snackbarErro = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Não foi possível realizar o login'),
          Icon(Icons.error)
        ],
      ),
      backgroundColor: Colors.red,
    );

    if (formularioValido && !_carregando) {
      setState(() => _carregando = true);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        final loginRealizadoComSucesso = await _autenticacaoService.login(
            usuario: _cpfEC.text, senha: _passwordEC.text);

        setState(() => _carregando = false);
        if (loginRealizadoComSucesso) {
          ScaffoldMessenger.of(context).showSnackBar(_snackbarSucesso);

          Navigator.pushReplacementNamed(context, '/home');
          _cpfEC.clear();
          _passwordEC.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(_snackbarLoginInvalido);
        }
      } catch (e) {
        print(e.toString());
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(_snackbarErro);
      }
    }
  }

  _checkarToken() async {
    if (!_verificouToken) {
      try {
        setState(() => _carregando = true);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        bool isTokenValido = await _autenticacaoService.isTokenValido();
        if (isTokenValido) Navigator.pushReplacementNamed(context, '/home');
      } finally {
        setState(() {
          _carregando = false;
          _verificouToken = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkarToken();

    final _campoLoginOperador = TextFormField(
      controller: _cpfEC,
      validator: Validatorless.multiple([
        Validatorless.required('Preencha o campo CPF'),
        Validatorless.cpf('CPF inválido'),
      ]),
      autofocus: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "CPF",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.article_outlined),
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
    );

    final _campoSenha = TextFormField(
      controller: _passwordEC,
      keyboardType: TextInputType.text,
      validator: Validatorless.multiple(
          [Validatorless.required('Preecha o campo senha')]),
      autofocus: true,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Senha",
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: Icon(Icons.remove_red_eye),
      ),
    );

    final _formulario = Form(
      key: _formKey,
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
              _campoLoginOperador,
              const SizedBox(
                height: 25,
              ),
              _campoSenha,
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
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: [Theme.of(context).primaryColor, Colors.blue]),
                  ),
                  child: MaterialButton(
                      onPressed: _onRealizarLogin,
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))),
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

    return Padding(
        padding: const EdgeInsets.all(30),
        child: _carregando
            ? ContainerCarregando(child: _formulario)
            : _formulario);
  }
}
