class StudentModel {
  final String nomComplet;
  final String authId;
  final String matricule;
  final bool maladeCr;
  final int totalAbsences;
  final int totalPresences;
  final int absencesJustifiees;
  final int absencesNonJustifiees;

  StudentModel({
    required this.nomComplet,
    required this.authId,
    required this.matricule,
    required this.maladeCr,
    required this.totalAbsences,
    required this.totalPresences,
    required this.absencesJustifiees,
    required this.absencesNonJustifiees,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      nomComplet: json['nomComplet'] ?? '',
      authId: json['authId'] ?? '',
      matricule: json['matricule'] ?? '',
      maladeCr: json['maladeCr'] ?? false,
      totalAbsences: json['totalAbsences'] ?? 0,
      totalPresences: json['totalPresences'] ?? 0,
      absencesJustifiees: json['absencesJustifiees'] ?? 0,
      absencesNonJustifiees: json['absencesNonJustifiees'] ?? 0,
    );
  }
}
