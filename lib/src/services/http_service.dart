import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri _parseUrl(String url) => Uri.parse("${dotenv.env['API_URL']}$url");

Future<http.Response> get(String url, {Map<String, String>? headers}) =>
    http.get(_parseUrl(url), headers: headers).timeout(const Duration(seconds: 2), onTimeout: () => http.Response('Error', 408));

Future<http.Response> post(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) => http
    .post(_parseUrl(url), headers: headers, body: body, encoding: encoding)
    .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('Error', 408));
