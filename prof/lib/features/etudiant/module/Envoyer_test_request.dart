class EnvoyerTestRequest {
  final String titre;
  final String niveau;
  final String specialite;
  final List<int> groupe;
  final int matiereId;
  final String date;
  final String heureDebut;
  final String heureFin;
  final String salle;

  EnvoyerTestRequest({
    required this.titre,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.matiereId,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
  });

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'niveau': niveau,
    'specialite': specialite,
    'groupe': groupe,
    'matiereId': matiereId,
    'date': date,
    'heureDebut': heureDebut,
    'heureFin': heureFin,
    'salle': salle,
  };
}
