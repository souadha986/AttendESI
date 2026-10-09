class CourseSlotModel {
  final int id;
  final String jour;
  final String section;
  final List<String> groupe;
  final String heure;
  final String matiere;
  final String professeur;
  final String salle;
  final String specialite;
  final String type;

  const CourseSlotModel({
    required this.id,
    required this.jour,
    required this.section,
    required this.groupe,
    required this.heure,
    required this.matiere,
    required this.professeur,
    required this.salle,
    required this.specialite,
    required this.type,
  });

  factory CourseSlotModel.fromJson(Map<String, dynamic> json) {
    return CourseSlotModel(
      id: json['id'] as int,
      jour: json['jour'] as String,
      section: json['section'] as String,
      groupe: List<String>.from(json['groupe']),
      heure: json['heure'] as String,
      matiere: json['matiere'] as String,
      professeur: json['professeur'] as String,
      salle: json['salle'] as String,
      specialite: json['specialite'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'jour': jour,
    'section': section,
    'groupe': groupe,
    'heure': heure,
    'matiere': matiere,
    'professeur': professeur,
    'salle': salle,
    'specialite': specialite,
    'type': type,
  };
}


class EmploiNormalModel {
  final Map<String, List<CourseSlotModel>> schedule;

  const EmploiNormalModel({required this.schedule});

  factory EmploiNormalModel.fromJson(Map<String, dynamic> json) {
    final map = <String, List<CourseSlotModel>>{};
    json.forEach((jour, slots) {
      map[jour] = (slots as List)
          .map((s) => CourseSlotModel.fromJson(s as Map<String, dynamic>))
          .toList();
    });
    return EmploiNormalModel(schedule: map);
  }
}