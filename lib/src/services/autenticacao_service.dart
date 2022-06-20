import 'dart:convert';

import 'package:almox_mobile/src/model/operador_model.dart';
import 'package:almox_mobile/src/services/configuracao_service.dart';
import 'package:almox_mobile/src/services/http_service.dart' as _http;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AutenticacaoService {
  static final AutenticacaoService _instance = AutenticacaoService.internal();
  factory AutenticacaoService() => _instance;
  AutenticacaoService.internal();

  final ConfiguracaoService _configuracaoService = ConfiguracaoService();
  OperadorModel? _operadorLogado;

  Future<bool> login({required String usuario, required String senha}) async {
    final clientId = dotenv.env['CLIENT_ID'];
    final clientSecret = dotenv.env['CLIENT_SECRET'];
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

    Map<String, dynamic> formMap = {
      "grant_type": "password",
      "username": usuario.replaceAll(RegExp('[^0-9]'), ''),
      "password": senha,
    };

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": basicAuth
    };

    final response = await _http.post(
      '/oauth/token',
      headers: headers,
      body: formMap,
    );
    await _configuracaoService.atualizarConfiguracao(
        "autenticacao", json.decode(response.body));
    return response.statusCode == 200;
  }

  Future<void> solicitarAcesso({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
  }) async {
    Map<String, dynamic> body = {
      "nome": nome,
      "cpf": cpf,
      "email": email,
      "senha": senha,
    };

    final response = await _http.post(
      '/operadores/solicitacoes-cadastro',
      body: json.encode(body),
      headers: {
        'Authorization': '',
      },
    );
  }

  Future<void> logout() async {
    await _configuracaoService
        .atualizarConfiguracao("autenticacao", {"access_token": null});
    _operadorLogado = null;
  }

  Future<http.Response?> _checkarToken() async {
    final Map<String, dynamic>? configuracoes =
        (await _configuracaoService.configuracao);
    if (configuracoes == null) return null;

    final Map? configuracoesAutenticacao =
        configuracoes["autenticacao"] as Map?;
    if (configuracoesAutenticacao == null) return null;

    String? token = configuracoesAutenticacao["access_token"];
    if (token == null) return null;

    return await http
        .post(
          _http.parseUrl('/oauth/check_token', {'token': token}),
        )
        .timeout(
          const Duration(seconds: 2),
          onTimeout: () => http.Response('Error', 408),
        );
  }

  Future<bool> isTokenValido() async {
    final response = await _checkarToken();
    if (response == null) return false;
    return response.statusCode == 200;
  }

  Future<String> get accessToken async {
    final Map<String, dynamic> configuracoes =
        (await _configuracaoService.configuracao ?? {})["autenticacao"];
    return configuracoes["access_token"];
  }

  Future<OperadorModel?> get operadorLogado async {
    if (_operadorLogado != null) return _operadorLogado;

    final response = await _checkarToken();
    if (response == null || response.statusCode != 200) return null;

    _operadorLogado =
        OperadorModel.fromJson(json.decode(response.body)['operador']);
    return _operadorLogado;
  }
}
