class AbsenceModel {
  final String professorName;
  final String todayDate;
  final List<StatModule> statistics;

  AbsenceModel({
    required this.professorName,
    required this.todayDate,
    required this.statistics,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) => AbsenceModel(
    professorName: json['professorName'] ?? '',
    todayDate: json['todayDate'] ?? '',
    statistics: (json['statistics'] as List)
        .map((e) => StatModule.fromJson(e))
        .toList(),
  );
}

class StatModule {
  final String title;
  final String level;
  final String specialite;
  final String group;
  final double totalAbsence;
  final double justifiedAbsence;

  StatModule({
    required this.title,
    required this.level,
    required this.specialite,
    required this.group,
    required this.totalAbsence,
    required this.justifiedAbsence,
  });

  factory StatModule.fromJson(Map<String, dynamic> json) => StatModule(
    title: json['title'] ?? '',
    level: json['level'] ?? '',
    specialite: json['specialite'] ?? '',
    group: json['group'] ?? '',
    totalAbsence: (json['totalAbsence'] ?? 0).toDouble(),
    justifiedAbsence: (json['justifiedAbsence'] ?? 0).toDouble(),
  );
}
