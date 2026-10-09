class AbsenceModifModels {
  int? totalLignes;
  int? totalInscrits;
  int? totalAbsents;
  List<Absence>? absences;

  AbsenceModifModels({
    this.totalLignes,
    this.totalInscrits,
    this.totalAbsents,
    this.absences,
  });

  factory AbsenceModifModels.fromJson(Map<String, dynamic> json) {
    return AbsenceModifModels(
      totalLignes: json['totalLignes'],
      totalInscrits: json['totalInscrits'],
      totalAbsents: json['totalAbsents'],
      absences: json['absences'] != null
          ? List<Absence>.from(
              json['absences'].map((x) => Absence.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLignes': totalLignes,
      'totalInscrits': totalInscrits,
      'totalAbsents': totalAbsents,
      'absences': absences != null
          ? absences!.map((x) => x.toJson()).toList()
          : [],
    };
  }
}

class Absence {
  int? absenceId;
  int? examenId;
  String? salle;
  String? niveau;
  String? module;
  String? specialite;
  String? typeSeance;
  DateTime? date;
  String? heureDebut;
  int? effectif;
  int? nbAbsents;

  Absence({
    this.absenceId,
    this.examenId,
    this.salle,
    this.niveau,
    this.module,
    this.specialite,
    this.typeSeance,
    this.date,
    this.heureDebut,
    this.effectif,
    this.nbAbsents,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      absenceId: json['absenceId'],
      examenId: json['examenId'],
      salle: json['salle'],
      niveau: json['niveau'],
      module: json['module'],
      specialite: json['specialite'],
      typeSeance: json['typeSeance'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      heureDebut: json['heureDebut'],
      effectif: json['effectif'],
      nbAbsents: json['nbAbsents'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'absenceId': absenceId,
      'examenId': examenId,
      'salle': salle,
      'niveau': niveau,
      'module': module,
      'specialite': specialite,
      'typeSeance': typeSeance,
      'date': date?.toIso8601String(),
      'heureDebut': heureDebut,
      'effectif': effectif,
      'nbAbsents': nbAbsents,
    };
  }
}

///////////////////////////////////////////////////////////////////////////////
class ModifListeModel {
  String? entete;
  int? absenceId;
  dynamic examenId;
  String? salle;
  String? niveau;
  String? module;
  String? specialite;
  DateTime? date;
  String? heureDebut;
  String? typeSeance;
  Stats? stats;
  List<Etudiant>? etudiants;

  ModifListeModel({
    this.entete,
    this.absenceId,
    this.examenId,
    this.salle,
    this.niveau,
    this.module,
    this.specialite,
    this.date,
    this.heureDebut,
    this.typeSeance,
    this.stats,
    this.etudiants,
  });

  factory ModifListeModel.fromJson(Map<String, dynamic> json) {
    return ModifListeModel(
      entete: json['entete'],
      absenceId: json['absenceId'],
      examenId: json['examenId'],
      salle: json['salle'],
      niveau: json['niveau'],
      module: json['module'],
      specialite: json['specialite'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      heureDebut: json['heureDebut'],
      typeSeance: json['typeSeance'],
      stats: json['stats'] != null ? Stats.fromJson(json['stats']) : null,
      etudiants: json['etudiants'] != null
          ? List<Etudiant>.from(
              json['etudiants'].map((x) => Etudiant.fromJson(x)))
          : [],
    );
  }
}

class Etudiant {
  int? num;
  String? authId;
  String? nom;
  String? prenom;
  String? matricule;
  dynamic specialite;
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

class ModifAbsence {
  List<String>? absences;
  List<String>? presences;

  ModifAbsence({
    this.absences,
    this.presences,
  });

  factory ModifAbsence.fromJson(Map<String, dynamic> json) {
    return ModifAbsence(
      absences: json['absences'] != null
          ? List<String>.from(json['absences'])
          : [],
      presences: json['presences'] != null
          ? List<String>.from(json['presences'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "absences": absences ?? [],
      "presences": presences ?? [],
    };
  }
}

class ModifAbsenceResponse {
  String? message;
  int? id;
  int? nbAbsents;

  ModifAbsenceResponse({
    this.message,
    this.id,
    this.nbAbsents,
  });

  factory ModifAbsenceResponse.fromJson(Map<String, dynamic> json) {
    return ModifAbsenceResponse(
      message: json['message'],
      id: json['id'],
      nbAbsents: json['nbAbsents'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "id": id,
      "nbAbsents": nbAbsents,
    };
  }
}