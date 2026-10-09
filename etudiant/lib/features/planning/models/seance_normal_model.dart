class SeanceNormaleModel {
  final String jour;
  final List<Seance> seances;

  SeanceNormaleModel({required this.jour, required this.seances});

  factory SeanceNormaleModel.fromJson(Map<String, dynamic> json) {
    return SeanceNormaleModel(
      jour: json['jour'],
      seances: (json['seances'] as List)
          .map((e) => Seance.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'jour': jour,
    'seances': seances.map((e) => e.toJson()).toList(),
  };

  static List<SeanceNormaleModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => SeanceNormaleModel.fromJson(e)).toList();
  }

  @override
  String toString() {
    return 'SeanceNormaleModel(jour: $jour, seances: $seances)';
  }
}

class Seance {
  final int id;
  final DateTime heureDebut;
  final DateTime heureFin;
  final String salle;
  final String typeSeance;
  final String nomMatiere;
  final String nomProfesseur;

  Seance({
    required this.id,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
    required this.typeSeance,
    required this.nomMatiere,
    required this.nomProfesseur,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json['id'],
      heureDebut: DateTime.parse(json['heureDebut']),
      heureFin: DateTime.parse(json['heureFin']),
      salle: json['salle'],
      typeSeance: json['typeSeance'],
      nomMatiere: json['nomMatiere'],
      nomProfesseur: json['nomProfesseur'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'heureDebut': heureDebut.toIso8601String(),
    'heureFin': heureFin.toIso8601String(),
    'salle': salle,
    'typeSeance': typeSeance,
    'nomMatiere': nomMatiere,
    'nomProfesseur': nomProfesseur,
  };

  @override
  String toString() {
    return 'Seance(id: $id, heureDebut: $heureDebut, heureFin: $heureFin, '
        'salle: $salle, typeSeance: $typeSeance, nomMatiere: $nomMatiere, '
        'nomProfesseur: $nomProfesseur)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Seance && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
