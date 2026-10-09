class AbsenceModuleModel {
  final String matiere;
  final int totalAbsences;
  final int absencesJustifiees;
  final double tauxTotal;
  final double tauxJustifie;
  final bool critique;
  final bool is_exclus;

  AbsenceModuleModel({
    required this.matiere,
    required this.totalAbsences,
    required this.absencesJustifiees,
    required this.tauxTotal,
    required this.tauxJustifie,
    required this.critique,
    required this.is_exclus,
  });

  factory AbsenceModuleModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModuleModel(
      matiere: json['matiere'] ?? '',
      totalAbsences: json['total_absences'] ?? 0,
      absencesJustifiees: json['absences_justifiees'] ?? 0,
      tauxTotal: (json['taux_total'] ?? 0).toDouble(),
      tauxJustifie: (json['taux_justifie'] ?? 0).toDouble(),
      critique: json['critique'] ?? false,
      is_exclus: json['is_exclus'] ?? false,
    );
  }
}
