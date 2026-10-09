class GenerateQrModel {
  final int matiereId;
  final int groupe;
  final String niveau;
  final String specialite;
  final String heureDebut;

  GenerateQrModel({
    required this.matiereId,
    required this.groupe,
    required this.niveau,
    required this.specialite,
    required this.heureDebut,
  });

  Map<String, dynamic> toJson() => {
    'matiereId': matiereId,
    'groupe': groupe,
    'niveau': niveau,
    'specialite': specialite,
    'heureDebut': heureDebut,
  };
}
