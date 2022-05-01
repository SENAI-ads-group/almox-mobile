import 'dart:convert';

import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/services/http_service.dart' as _http;

class ProdutoService {
  static final ProdutoService _instance = ProdutoService.internal();
  factory ProdutoService() => _instance;
  ProdutoService.internal();

  Future<List<ProdutoModel>> fetchProdutos() async {
    try {
      final response = await _http.get("/produtos");

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return (json['data'] as List<dynamic>).map((jsonData) => ProdutoModel.fromJson(jsonData)).toList();
      } else {
        throw Exception('Não foi possível carregar os produtos');
      }
    } catch (e) {
      throw Exception('Não foi possível carregar os produtos');
    }
  }
}
