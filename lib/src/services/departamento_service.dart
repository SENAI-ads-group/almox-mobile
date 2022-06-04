import 'dart:convert';
import 'package:almox_mobile/src/services/http_service.dart' as _http;
import '../model/departamento_model.dart';

class DepartamentoService {
  static final DepartamentoService _instance = DepartamentoService.internal();
  factory DepartamentoService() => _instance;
  DepartamentoService.internal();

  Future<List<DepartamentoModel>> fetchDepartamentos({String? descricao}) async {
    final Map<String, dynamic> queryParameters = {};
    if (descricao != null) queryParameters['descricao'] = descricao;

    final response = await _http.get("/departamentos", queryParameters: queryParameters);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>).map((jsonData) => DepartamentoModel.fromJson(jsonData)).toList();
    } else {
      throw Exception('Não foi possível carregar os departamentos');
    }
  }
}
