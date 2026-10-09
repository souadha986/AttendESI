class MarquerAbsenceRequest {
  final int matiereId;
  final String date;
  final String niveau;
  final String specialite;
  final int groupe;
  final String heureDebut;
  final List<String> absents;
  final List<String> presents;

  MarquerAbsenceRequest({
    required this.heureDebut,
    required this.matiereId,
    required this.date,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.absents,
    required this.presents,
  });

  Map<String, dynamic> toJson() => {
    'heureDebut': heureDebut,
    'matiereId': matiereId,
    'date': date,
    'niveau': niveau,
    'specialite': specialite,
    'groupe': groupe,
    'absents': absents,
    'presents': presents,
  };
}
