import 'package:intl/intl.dart';

class ExamenModel {
  final DateTime date;
  final List<ActiviteExamen> activites;

  ExamenModel({required this.date, required this.activites});

  factory ExamenModel.fromJson(Map<String, dynamic> json) {
    return ExamenModel(
      date: DateTime.parse(json['date']),
      activites:
          (json['activites'] as List?)
              ?.map((a) => ActiviteExamen.fromJson(a))
              .toList() ??
          [],
    );
  }

  // Helper pour afficher la date (ex: Vendredi 15 Mai)
  String get dateFormatee => DateFormat('EEEE d MMMM', 'fr_FR').format(date);

  // Helper pour extraire le nom du jour (ex: Vendredi)
  String get jour => DateFormat('EEEE', 'fr_FR').format(date);
}

class ActiviteExamen {
  final int id;
  final DateTime? heureDebut;
  final DateTime? heureFin;
  final String? matiere;
  final String? salle;
  final String? promo;
  final String? specialite;
  final String? role;
  final List<String>? tousResponsables;
  final List<String>? tousSurveillants;

  ActiviteExamen({
    required this.id,
    this.heureDebut,
    this.heureFin,
    required this.matiere,
    required this.salle,
    required this.promo,
    this.specialite,
    required this.role,
    required this.tousResponsables,
    required this.tousSurveillants,
  });

  factory ActiviteExamen.fromJson(Map<String, dynamic> json) {
    return ActiviteExamen(
      id: json['id'] ?? 0,
      heureDebut: json['heureDebut'] != null
          ? DateTime.parse(json['heureDebut'])
          : null,
      heureFin: json['heureFin'] != null
          ? DateTime.parse(json['heureFin'])
          : null,
      matiere: json['matiere'] ?? '',
      salle: json['salle'] ?? '',
      promo: json['promo'] ?? '',
      specialite: json['specialite'],
      role: json['role'] ?? '',
      tousResponsables: List<String>.from(json['tousResponsables'] ?? []),
      tousSurveillants: List<String>.from(json['tousSurveillants'] ?? []),
    );
  }

  // Formate l'heure de début et fin (ex: 09:00 - 11:00)
  String get timeRange {
    if (heureDebut == null || heureFin == null) return "--:--";
    String start = DateFormat('HH:mm').format(heureDebut!.toLocal());
    String end = DateFormat('HH:mm').format(heureFin!.toLocal());
    return "$start - $end";
  }
}
