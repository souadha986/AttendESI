class SeanceNormaleModel {
  final String jour;
  final String nomCompletProf;
  final List<Seance> seances;

  SeanceNormaleModel({
    required this.jour,
    required this.nomCompletProf,
    required this.seances,
  });

  factory SeanceNormaleModel.fromJson(Map<String, dynamic> json) {
    return SeanceNormaleModel(
      jour: json['jour'] ?? '',
      nomCompletProf: json['nomCompletProf'] ?? '',
      seances:
          (json['seances'] as List?)?.map((s) => Seance.fromJson(s)).toList() ??
          [],
    );
  }
}

class Seance {
  final int id;
  final DateTime? heureDebut;
  final DateTime? heureFin;
  final String salle;
  final String typeSeance;
  final String situation;
  final String specialite;
  final String? section;
  final List<String> groupe;
  final String nomMatiere;

  Seance({
    required this.id,
    this.heureDebut,
    this.heureFin,
    required this.salle,
    required this.typeSeance,
    required this.situation,
    required this.specialite,
    this.section,
    required this.groupe,
    required this.nomMatiere,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json['id'] ?? 0,
      heureDebut: json['heureDebut'] != null
          ? DateTime.parse(json['heureDebut'])
          : null,
      heureFin: json['heureFin'] != null
          ? DateTime.parse(json['heureFin'])
          : null,
      salle: json['salle'] ?? '',
      typeSeance: json['typeSeance'] ?? '',
      situation: json['situation'] ?? '',
      specialite: json['specialite'] ?? '',
      section: json['section']?.toString(),
      groupe: List<String>.from(json['groupe'] ?? []),
      nomMatiere: json['nomMatiere'] ?? '',
    );
  }

  // Helper to format time as 09:00
  String get timeRange {
    if (heureDebut == null || heureFin == null) return "--:--";
    String start =
        "${heureDebut!.hour.toString().padLeft(2, '0')}:${heureDebut!.minute.toString().padLeft(2, '0')}";
    String end =
        "${heureFin!.hour.toString().padLeft(2, '0')}:${heureFin!.minute.toString().padLeft(2, '0')}";
    return "$start-$end";
  }
}
