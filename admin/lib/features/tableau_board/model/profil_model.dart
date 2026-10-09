class ProfilModel {
  final String? nomComplet;

  ProfilModel({this.nomComplet});

  factory ProfilModel.fromJson(Map<String, dynamic> json) {
    return ProfilModel(
      nomComplet: json['nomComplet'],
    );
  }
}