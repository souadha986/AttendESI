class EnvoyerTestRemplacementRequest {
  final String titre;
  final String niveau;
  final String specialite;
  final List<int> groupe;
  final List<String> targetStudent;
  final int matiereId;
  final String dateAbsence;
  final String dateRemplacement;
  final String heureDebut;
  final String heureFin;
  final String salle;

  EnvoyerTestRemplacementRequest({
    required this.targetStudent,
    required this.titre,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.matiereId,
    required this.dateAbsence,
    required this.dateRemplacement,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
  });

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'niveau': niveau,
    'specialite': specialite,
    'groupIds': groupe,
    'matiereId': matiereId,
    'date': dateRemplacement,
    'dateAbsence': dateAbsence,
    'heureDebut': heureDebut,
    'heureFin': heureFin,
    'salle': salle,
    'targetStudentIds': targetStudent,
  };
}
