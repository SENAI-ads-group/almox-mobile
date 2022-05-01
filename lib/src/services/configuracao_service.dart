import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ConfiguracaoService {
  static final ConfiguracaoService _instance = ConfiguracaoService.internal();
  factory ConfiguracaoService() => _instance;
  ConfiguracaoService.internal() {
    _localPath.then((dir) => File('$dir/configuracao.json').create(recursive: true).then((File file) => file.writeAsString("{}")));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _configurationFile async {
    String dir = await _localPath;
    return File('$dir/configuracao.json');
  }

  Future<void> atualizarConfiguracao(String chave, dynamic valor) async {
    File file = await _configurationFile;
    Map<String, dynamic> mapaConfiguracoes = json.decode(await file.readAsString());
    mapaConfiguracoes[chave] = valor;
    final content = jsonEncode(mapaConfiguracoes);
    file.writeAsString(content);
  }

  Future<Map<String, dynamic>> get configuracao async {
    File file = await _configurationFile;
    return json.decode(await file.readAsString());
  }
}
