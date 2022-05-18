import 'dart:convert';
import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/services/http_service.dart' as _http;

class RequisicaoService {
  static final RequisicaoService _instance = RequisicaoService.internal();
  factory RequisicaoService() => _instance;
  RequisicaoService.internal();

  Future<void> criarRequisicao(CriarRequisicao criarRequisicao) async {
    final Map<String, dynamic> body = {
      "idOperadorAlmoxarife": criarRequisicao.idOperadorAlmoxarife,
      "idDepartamento": criarRequisicao.idDepartamento,
      "itens": criarRequisicao.itens,
    };

    final response = await _http.post('/requisicoes', body: json.encode(body));
    if (response.statusCode != 201) {
      throw Exception('Não foi possível criar a requisição');
    }
  }

  Future<void> atenderRequisicao(String id) async {
    final response = await _http.post('/requisicoes/' + id + '/atender');
    if (response.statusCode != 202) {
      throw Exception('Não foi possível atender a requisição');
    }
  }

  Future<void> entregarRequisicao(String id) async {
    final response = await _http.post('/requisicoes/' + id + '/entregar');
    if (response.statusCode != 202) {
      print(response.statusCode);
      print(response.body);
      throw Exception('Não foi possível entregar a requisição');
    }
  }

  Future<void> cancelarRequisicao(String id) async {
    final response = await _http.post('/requisicoes/' + id + '/cancelar');
    if (response.statusCode != 202) {
      throw Exception('Não foi possível cancelar a requisição');
    }
  }

  Future<List<RequisicaoModel>> fetchRequisicao() async {
    final response = await _http.get('/requisicoes');

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return (json['data'] as List<dynamic>).map((jsonData) => RequisicaoModel.fromJson(jsonData)).toList();
    } else {
      throw Exception('Não foi possível carregar as Requisições');
    }
  }
}
