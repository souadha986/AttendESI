class FiltreModel {
  List<String>? niveaux;
  Map<String, List<MatieresByNiveau>>? matieresByNiveau;
  Map<String, List<String>>? specialitesByNiveau;
  List<String>? salles;
  List<DateTime>? dates;

  FiltreModel({
    this.niveaux,
    this.matieresByNiveau,
    this.specialitesByNiveau,
    this.salles,
    this.dates,
  });
  factory FiltreModel.fromJson(Map<String, dynamic> json) {
    return FiltreModel(
      niveaux: List<String>.from(json['niveaux'] ?? []),

      matieresByNiveau: (json['matieresByNiveau'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => MatieresByNiveau.fromJson(e)).toList(),
        ),
      ),

      specialitesByNiveau: (json['specialitesByNiveau'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, List<String>.from(value))),

      salles: List<String>.from(json['salles'] ?? []),

      dates: (json['dates'] as List?)?.map((e) => DateTime.parse(e)).toList(),
    );
  }
}

class MatieresByNiveau {
  int? id;
  String? nom;

  MatieresByNiveau({this.id, this.nom});

  factory MatieresByNiveau.fromJson(Map<String, dynamic> json) {
    return MatieresByNiveau(id: json['id'], nom: json['nom']);
  }
}


class AbsenceModels {
    String? entete;
    Examen? examen;
    bool? dejaValide;
    Stats? stats;
    List<Etudiant>? etudiants;

    AbsenceModels({
        this.entete,
        this.examen,
        this.dejaValide,
        this.stats,
        this.etudiants,
    });
    factory AbsenceModels.fromJson(Map<String, dynamic> json) {
  return AbsenceModels(
    entete: json['entete'],
    examen: json['examen'] != null
        ? Examen.fromJson(json['examen'])
        : null,
    dejaValide: json['dejaValide'],
    stats: json['stats'] != null
        ? Stats.fromJson(json['stats'])
        : null,
    etudiants: (json['etudiants'] as List?)
        ?.map((e) => Etudiant.fromJson(e))
        .toList(),
  );
}

}

class Etudiant {
    int? num;
    String? authId;
    String? nom;
    String? prenom;
    String? matricule;
    String? specialite;
    String? statut;

    Etudiant({
        this.num,
        this.authId,
        this.nom,
        this.prenom,
        this.matricule,
        this.specialite,
        this.statut,
    });
    factory Etudiant.fromJson(Map<String, dynamic> json) {
  return Etudiant(
    num: json['num'],
    authId: json['auth_id'],
    nom: json['nom'],
    prenom: json['prenom'],
    matricule: json['matricule'],
    specialite: json['specialite'],
    statut: json['statut'],
  );
}

}

class Examen {
    int? id;
    String? matiere;
    String? salle;
    DateTime? date;
    String? heureDebut;
    String? heureFin;

    Examen({
        this.id,
        this.matiere,
        this.salle,
        this.date,
        this.heureDebut,
        this.heureFin,
    });
    factory Examen.fromJson(Map<String, dynamic> json) {
  return Examen(
    id: json['id'],
    matiere: json['matiere'],
    salle: json['salle'],
    date: json['date'] != null
        ? DateTime.parse(json['date'])
        : null,
    heureDebut: json['heureDebut'],
    heureFin: json['heureFin'],
  );
}

}

class Stats {
    int? totalInscrits;
    int? totalAbsents;

    Stats({
        this.totalInscrits,
        this.totalAbsents,
    });
    factory Stats.fromJson(Map<String, dynamic> json) {
  return Stats(
    totalInscrits: json['totalInscrits'],
    totalAbsents: json['totalAbsents'],
  );
}

}

class ValiderAbsenceModel {
  final String situation;
  final int examenId;
  final List<String> absences;
  final List<String> presences;

  ValiderAbsenceModel({
    required this.situation,
    required this.examenId,
    required this.absences,
    required this.presences,
  });

  Map<String, dynamic> toJson() {
    return {
      "situation": situation,
      "examenId": examenId,
      "absences": absences,
      "presences": presences,
    };
  }
}

class ValiderAbsenceResponse {
  final String? message;
  final int? id;

  ValiderAbsenceResponse({this.message, this.id});

  factory ValiderAbsenceResponse.fromJson(Map<String, dynamic> json) {
    return ValiderAbsenceResponse(
      message: json['message'],
      id: json['id'],
    );
  }
}
