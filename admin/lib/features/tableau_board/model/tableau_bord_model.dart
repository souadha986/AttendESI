class CardsModel {
  Stats? stats;
  List<Chart>? chart;

  CardsModel({this.stats, this.chart});

  factory CardsModel.fromJson(Map<String, dynamic> json) {
    return CardsModel(
      stats: json['stats'] != null ? Stats.fromJson(json['stats']) : null,
      chart: json['chart'] != null
          ? List<Chart>.from(json['chart'].map((x) => Chart.fromJson(x)))
          : [],
    );
  }
}

class Chart {
  String? module;
  int? count;

  Chart({this.module, this.count});

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(module: json['module'] ?? '', count: json['count'] ?? 0);
  }
}

class Stats {
  String? currentDate;
  int? absencesToday;
  AbsencesTrend? absencesTrend;
  int? chronicDiseases;
  int? procheExclusion;
  String? globalRate;

  Stats({
    this.currentDate,
    this.absencesToday,
    this.absencesTrend,
    this.chronicDiseases,
    this.procheExclusion,
    this.globalRate,
  });

 factory Stats.fromJson(Map<String, dynamic> json) {
  return Stats(
    currentDate: json['currentDate'] ?? '',
    absencesToday: json['absencesToday'] ?? 0,
    absencesTrend: json['absencesTrend'] != null
        ? AbsencesTrend.fromJson(json['absencesTrend'])
        : null,
    chronicDiseases: json['chronicDiseases'] ?? 0,
    procheExclusion: json['procheExclusion'] ?? 0,
    globalRate: json['globalRate'] ?? '',
  );
}
}

class AbsencesTrend {
  String? percentage;
  bool? isUp;

  AbsencesTrend({this.percentage, this.isUp});

  factory AbsencesTrend.fromJson(Map<String, dynamic> json) {
  return AbsencesTrend(
    percentage: json['percentage'] ?? '',
    isUp: json['isUp'] ?? false,
  );
}
}

class NiveauModel {
  final String niveau;

  NiveauModel({required this.niveau});

  factory NiveauModel.fromJson(dynamic json) {
    return NiveauModel(niveau: json.toString());
  }
}

class SpecialiteModel {
  final String specialite;

  SpecialiteModel({required this.specialite});

  factory SpecialiteModel.fromJson(dynamic json) {
    return SpecialiteModel(specialite: json.toString());
  }
}
class ChartModel {
  String? module;
  double? percentage;
  int? activeStudents;

  ChartModel({
    this.module,
    this.percentage,
    this.activeStudents
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      module: json['module'] ?? '',
      percentage: json['percentage'] ?? 0,
      activeStudents: json['activeStudents'] ?? 0,
    );
  }
}