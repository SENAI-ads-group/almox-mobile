import 'dart:convert';
import 'dart:io';

import 'package:almox_mobile/src/services/autenticacao_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final AutenticacaoService _autenticacaoService = AutenticacaoService();

Uri _parseUrl(String url, [Map<String, dynamic>? queryParameters]) => Uri.http("${dotenv.env['API_URL']}", url, queryParameters);

Future<Map<String, String>?> _configureHeaders(Map<String, String>? headers) async {
  final Map<String, String> finalHeaders = headers == null ? {} : {...headers};
  if (finalHeaders["Authorization"] == null) {
    String accessToken = await _autenticacaoService.accessToken;
    finalHeaders["Authorization"] = 'Bearer $accessToken';
  }
  return finalHeaders;
}

Future<http.Response> get(String url, {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async => http
    .get(
      _parseUrl(url, queryParameters),
      headers: await _configureHeaders(headers),
    )
    .timeout(
      const Duration(seconds: 5),
      onTimeout: () => http.Response('Error', 408),
    );

Future<http.Response> post(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  return http
      .post(
        _parseUrl(url),
        headers: await _configureHeaders(headers),
        body: body,
        encoding: encoding,
      )
      .timeout(
        const Duration(seconds: 5),
        onTimeout: () => http.Response('Error', 408),
      );
}
