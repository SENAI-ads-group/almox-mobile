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
}
