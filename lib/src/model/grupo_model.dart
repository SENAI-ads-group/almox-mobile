class GrupoModel {
  final String id;
  final String descricao;

  GrupoModel({required this.id, required this.descricao});

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(
      id: json['id'],
      descricao: json['descricao'],
    );
  }
}
