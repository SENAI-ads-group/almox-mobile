import 'dart:convert';

import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProdutoService {
  static final ProdutoService _instance = ProdutoService.internal();
  factory ProdutoService() => _instance;
  ProdutoService.internal();

  Future<List<ProdutoModel>> fetchProdutos() async {
    final response = await http
        .get(Uri.parse("${dotenv.env['API_URL']}/produtos"))
        .timeout(const Duration(seconds: 2), onTimeout: () => http.Response('Error', 408));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>).map((jsonData) => ProdutoModel.fromJson(jsonData)).toList();
    } else {
      throw Exception('Não foi possível carregar os produtos');
    }
  }
}
