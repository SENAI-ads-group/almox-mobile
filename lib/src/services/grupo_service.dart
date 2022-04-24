import 'dart:convert';

import 'package:almox_mobile/src/model/grupo_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GrupoService {
  static final GrupoService _instance = GrupoService.internal();
  factory GrupoService() => _instance;
  GrupoService.internal();

  Future<List<GrupoModel>> fetchGrupos() async {
    final response = await http
        .get(Uri.parse("${dotenv.env['API_URL']}/grupos"))
        .timeout(const Duration(seconds: 2), onTimeout: () => http.Response('Error', 408));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>).map((jsonData) => GrupoModel.fromJson(jsonData)).toList();
    } else {
      throw Exception('Não foi possível carregar os grupos');
    }
  }
}
