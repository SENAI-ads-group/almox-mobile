import 'dart:convert';

import 'package:almox_mobile/src/services/http_service.dart' as _http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AutenticacaoService {
  static final AutenticacaoService _instance = AutenticacaoService.internal();
  factory AutenticacaoService() => _instance;
  AutenticacaoService.internal();

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

    return response.statusCode == 200;
  }
}
