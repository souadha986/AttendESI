class ModifierAbsenceRequest {
  final String heureDebut;
  final int matiereId;
  final String dateStr;
  final String niveau;
  final String specialite;
  final int groupe;
  final List<String> absents;
  final List<String> presents;

  ModifierAbsenceRequest({
    required this.heureDebut,
    required this.matiereId,
    required this.dateStr,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.absents,
    required this.presents,
  });

  Map<String, dynamic> toJson() {
    return {
      "heureDebut": heureDebut,
      "matiereId": matiereId,
      "dateStr": dateStr,
      "niveau": niveau,
      "specialite": specialite,
      "groupe": groupe,
      "absents": absents,
      "presents": presents,
    };
  }
}
