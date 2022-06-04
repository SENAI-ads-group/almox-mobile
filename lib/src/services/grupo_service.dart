import 'dart:convert';

import 'package:almox_mobile/src/model/grupo_model.dart';
import 'package:almox_mobile/src/services/http_service.dart' as _http;

class GrupoService {
  static final GrupoService _instance = GrupoService.internal();
  factory GrupoService() => _instance;
  GrupoService.internal();

  Future<List<GrupoModel>> fetchGrupos() async {
    final response = await _http.get("/grupos");
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>).map((jsonData) => GrupoModel.fromJson(jsonData)).toList();
    } else {
      throw Exception('Não foi possível carregar os grupos');
    }
  }
}
