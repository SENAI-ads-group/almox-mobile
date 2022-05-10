import 'dart:convert';

import 'package:almox_mobile/src/services/configuracao_service.dart';
import 'package:almox_mobile/src/services/http_service.dart' as _http;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AutenticacaoService {
  static final AutenticacaoService _instance = AutenticacaoService.internal();
  factory AutenticacaoService() => _instance;
  AutenticacaoService.internal();

  final ConfiguracaoService _configuracaoService = ConfiguracaoService();

  Future<bool> login({required String usuario, required String senha}) async {
    final clientId = dotenv.env['CLIENT_ID'];
    final clientSecret = dotenv.env['CLIENT_SECRET'];
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

    Map<String, dynamic> formMap = {
      "grant_type": "password",
      "username": usuario.replaceAll(RegExp('[^0-9]'), ''),
      "password": senha,
    };

    Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded", "Authorization": basicAuth};

    final response = await _http.post(
      '/oauth/token',
      headers: headers,
      body: formMap,
    );
    _configuracaoService.atualizarConfiguracao("autenticacao", json.decode(response.body));
    return response.statusCode == 200;
  }

  Future<bool> isTokenValido() async {
    final Map<String, dynamic>? configuracoes = (await _configuracaoService.configuracao);
    if (configuracoes == null) return false;

    final Map? configuracoesAutenticacao = configuracoes["autenticacao"] as Map?;
    if (configuracoesAutenticacao == null) return false;

    String? token = configuracoesAutenticacao["access_token"];
    if (token == null) return false;

    final response = await http
        .post(
          _http.parseUrl('/oauth/check_token', {'token': token}),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => http.Response('Error', 408),
        );
    return response.statusCode == 200;
  }

  Future<String> get accessToken async {
    final Map<String, dynamic> configuracoes = (await _configuracaoService.configuracao ?? {})["autenticacao"];
    return configuracoes["access_token"];
  }
}
