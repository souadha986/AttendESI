class ExamModel {
  final String date;
  final List<Activite> activites;

  ExamModel({required this.date, required this.activites});

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      date: json['date'],
      activites: (json['activites'] as List)
          .map((e) => Activite.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'activites': activites.map((e) => e.toJson()).toList(),
  };

  static List<ExamModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ExamModel.fromJson(e)).toList();
  }

  @override
  String toString() => 'ExamModel(date: $date, activites: $activites)';
}

class Activite {
  final int id;
  final String jourNom;
  final DateTime heureDebut;
  final DateTime heureFin;
  final String salle;
  final String type;
  final String nomMatiere;

  Activite({
    required this.id,
    required this.jourNom,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
    required this.type,
    required this.nomMatiere,
  });

  factory Activite.fromJson(Map<String, dynamic> json) {
    return Activite(
      id: json['id'],
      jourNom: json['jourNom'],
      heureDebut: DateTime.parse(json['heureDebut']),
      heureFin: DateTime.parse(json['heureFin']),
      salle: json['salle'],
      type: json['type'],
      nomMatiere: json['nomMatiere'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'jourNom': jourNom,
    'heureDebut': heureDebut.toIso8601String(),
    'heureFin': heureFin.toIso8601String(),
    'salle': salle,
    'type': type,
    'nomMatiere': nomMatiere,
  };

  @override
  String toString() {
    return 'Activite(id: $id, jourNom: $jourNom, heureDebut: $heureDebut, '
        'heureFin: $heureFin, salle: $salle, type: $type, nomMatiere: $nomMatiere)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activite && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
