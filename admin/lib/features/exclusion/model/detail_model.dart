class DetailModel {
  String? nomComplet;
  String? module;
  int? absJustifiee;
  int? absNonJustifiee;
  List<Historique>? historique;
  bool? maladeCr;

  DetailModel({
    this.nomComplet,
    this.module,
    this.absJustifiee,
    this.absNonJustifiee,
    this.historique,
    this.maladeCr,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      nomComplet: json['nomComplet'] as String?,
      module: json['module'] as String?,
      absJustifiee: json['absJustifiee'] as int?,
      absNonJustifiee: json['absNonJustifiee'] as int?,
      historique: (json['historique'] as List<dynamic>?)
          ?.map((e) => Historique.fromJson(e as Map<String, dynamic>))
          .toList(),
      maladeCr: json['maladeCr'] as bool?,
    );
  }
}

class Historique {
  String? date;
  String? intervalleHeure;
  bool? isJustified;

  Historique({
    this.date,
    this.intervalleHeure,
    this.isJustified,
  });

  factory Historique.fromJson(Map<String, dynamic> json) {
    return Historique(
      date: json['date'] as String?,
      intervalleHeure: json['intervalleHeure'] as String?,
      isJustified: json['isJustified'] as bool?,
    );
  }
}