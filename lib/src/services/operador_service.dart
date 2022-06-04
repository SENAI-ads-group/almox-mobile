import 'dart:convert';
import 'package:almox_mobile/src/model/operador_model.dart';
import 'package:almox_mobile/src/services/http_service.dart' as _http;

class OperadorService {
  static final OperadorService _instance = OperadorService.internal();
  factory OperadorService() => _instance;
  OperadorService.internal();

  Future<List<OperadorModel>> fetchOperadores(
      {String? nome, String? email, String? cpf}) async {
    final Map<String, dynamic> queryParameters = {};
    if (nome != null) queryParameters['nome'] = nome;
    if (email != null) queryParameters['email'] = email;
    if (cpf != null) queryParameters['cpf'] = cpf;

    final response =
        await _http.get("/operadores", queryParameters: queryParameters);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>)
          .map((jsonData) => OperadorModel.fromJson(jsonData))
          .toList();
    } else {
      throw Exception('Não foi possível carregar os operadores');
    }
  }

  Future<List<OperadorModel>> fetchOperadoresAlmoxarifes(
      {String? nome, String? email, String? cpf}) async {
    final Map<String, dynamic> queryParameters = {};
    if (nome != null) queryParameters['nome'] = nome;
    if (email != null) queryParameters['email'] = email;
    if (cpf != null) queryParameters['cpf'] = cpf;

    final response = await _http.get("/operadores/almoxarifes",
        queryParameters: queryParameters);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>)
          .map((jsonData) => OperadorModel.fromJson(jsonData))
          .toList();
    } else {
      throw Exception('Não foi possível carregar os almoxarifes');
    }
  }
}
