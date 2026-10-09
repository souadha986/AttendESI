class NormalPlanning {
  final Agent? agent;
  final FiltersApplied? filtersApplied;
  final EmploiDuTemps? emploiDuTemps;

  NormalPlanning({this.agent, this.filtersApplied, this.emploiDuTemps});

  factory NormalPlanning.fromJson(Map<String, dynamic> json) {
    return NormalPlanning(
      agent: json['agent'] != null ? Agent.fromJson(json['agent']) : null,
      filtersApplied: json['filters_applied'] != null
          ? FiltersApplied.fromJson(json['filters_applied'])
          : null,
      emploiDuTemps: json['emploi_du_temps'] != null
          ? EmploiDuTemps.fromJson(json['emploi_du_temps'])
          : null,
    );
  }
}

class Agent {
  final String? nom;
  final String? prenom;
  final List<String>? niveauxAutorises;
  final String? cycleResponsable;

  Agent({this.nom, this.prenom, this.niveauxAutorises, this.cycleResponsable});

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      nom: json['nom'],
      prenom: json['prenom'],
      niveauxAutorises: (json['niveaux_autorises'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      cycleResponsable: json['cycle_responsable'],
    );
  }
}

class FiltersApplied {
  final String? niveau;
  final String? specialite;

  FiltersApplied({this.niveau, this.specialite});

  factory FiltersApplied.fromJson(Map<String, dynamic> json) {
    return FiltersApplied(
      niveau: json['niveau'],
      specialite: json['specialite'],
    );
  }
}

class EmploiDuTemps {
  final Map<String, Niveau>? niveaux;

  EmploiDuTemps({this.niveaux});

  factory EmploiDuTemps.fromJson(Map<String, dynamic> json) {
    return EmploiDuTemps(
      niveaux: json.map((key, value) {
        if (value == null || value is! Map<String, dynamic>) {
          return MapEntry(key, Niveau(specialites: {}));
        }
        return MapEntry(key, Niveau.fromJson(value));
      }),
    );
  }
}

class Niveau {
  final Map<String, Specialite>? specialites;

  Niveau({this.specialites});

  factory Niveau.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return Niveau(specialites: {});
    }

    return Niveau(
      specialites: json.map((key, value) {
        if (value == null || value is! Map<String, dynamic>) {
          return MapEntry(key, Specialite(jours: {}));
        }
        return MapEntry(key, Specialite.fromJson(value));
      }),
    );
  }
}

class Specialite {
  final Map<String, List<Seance>>? jours;

  Specialite({this.jours});

  factory Specialite.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return Specialite(jours: {});
    }

    return Specialite(
      jours: json.map((key, value) {
        if (value == null || value is! List) {
          return MapEntry(key, []);
        }

        return MapEntry(
          key,
          value.map((e) => Seance.fromJson(e as Map<String, dynamic>)).toList(),
        );
      }),
    );
  }
}

class Seance {
  final String? jour;
  final DateTime? heureDebut;
  final DateTime? heureFin;
  final String? typeSeance;
  final String? salle;
  final String? situation;
  final String? specialite;
  final List<String>? groupe;
  final String? section;
  final Matiere? matiere;
  final Professeur? professeur;

  Seance({
    this.jour,
    this.heureDebut,
    this.heureFin,
    this.typeSeance,
    this.salle,
    this.situation,
    this.specialite,
    this.groupe,
    this.section,
    this.matiere,
    this.professeur,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      jour: json['jour'],
      heureDebut: json['heureDebut'] != null
          ? DateTime.tryParse(json['heureDebut'])
          : null,
      heureFin: json['heureFin'] != null
          ? DateTime.tryParse(json['heureFin'])
          : null,
      typeSeance: json['typeSeance'],
      salle: json['salle'],
      situation: json['situation'],
      specialite: json['specialite'],
      groupe: (json['groupe'] as List?)?.map((e) => e.toString()).toList(),
      section: json['section'],
      matiere: json['matiere'] != null && json['matiere'] is Map
          ? Matiere.fromJson(json['matiere'])
          : null,
      professeur: json['professeur'] != null && json['professeur'] is Map
          ? Professeur.fromJson(json['professeur'])
          : null,
    );
  }
}

class Matiere {
  final String? nomMatiere;

  Matiere({this.nomMatiere});

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(nomMatiere: json['nom_matiere']);
  }
}

class Professeur {
  final String? nom;
  final String? prenom;

  Professeur({this.nom, this.prenom});

  factory Professeur.fromJson(Map<String, dynamic> json) {
    return Professeur(nom: json['nom'], prenom: json['prenom']);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////
class ExamPlanning {
  final Agent? agent;
  final Examens? examens;

  ExamPlanning({this.agent, this.examens});

  factory ExamPlanning.fromJson(Map<String, dynamic> json) {
    return ExamPlanning(
      agent: json['agent'] != null ? Agent.fromJson(json['agent']) : null,
      examens: json['examens'] != null
          ? Examens.fromJson(json['examens'])
          : null,
    );
  }
}

class Examens {
   final Map<String, NiveauExamen>? niveaux;

  bool get isEmpty =>
      niveaux == null ||
      niveaux!.isEmpty ||
      niveaux!.values.every(
        (niveau) =>
            niveau.specialites == null ||
            niveau.specialites!.isEmpty ||
            niveau.specialites!.values.every((list) => list.isEmpty),
      );

  Examens({this.niveaux});

  factory Examens.fromJson(Map<String, dynamic> json) {
    return Examens(
      niveaux: json.map((key, value) {
        if (value == null || value is! Map<String, dynamic>) {
          return MapEntry(key, NiveauExamen(specialites: {}));
        }
        return MapEntry(key, NiveauExamen.fromJson(value));
      }),
    );
  }
}

class NiveauExamen {
  final Map<String, List<Examen>>? specialites;

  NiveauExamen({this.specialites});

  factory NiveauExamen.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return NiveauExamen(specialites: {});
    }

    return NiveauExamen(
      specialites: json.map((key, value) {
        if (value == null || value is! List) {
          return MapEntry(key, []);
        }

        return MapEntry(
          key,
          value.map((e) => Examen.fromJson(e as Map<String, dynamic>)).toList(),
        );
      }),
    );
  }
}

class Examen {
  final int? id;
  final DateTime? date;
  final DateTime? heureDebut;
  final DateTime? heureFin;
  final String? salle;
  final String? type;
  final String? situation;
  final String? specialite;
  final List<String>? responsables;
  final List<String>? surveillances;
  final MatiereExamen? matiere;

  Examen({
    this.id,
    this.date,
    this.heureDebut,
    this.heureFin,
    this.salle,
    this.type,
    this.situation,
    this.specialite,
    this.responsables,
    this.surveillances,
    this.matiere,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      heureDebut: json['heureDebut'] != null
          ? DateTime.tryParse(json['heureDebut'])
          : null,
      heureFin: json['heureFin'] != null
          ? DateTime.tryParse(json['heureFin'])
          : null,
      salle: json['salle'],
      type: json['type'],
      situation: json['situation'],
      specialite: json['specialite'],
      responsables: (json['responsables'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      surveillances: (json['surveillances'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      matiere: json['matiere'] != null && json['matiere'] is Map
          ? MatiereExamen.fromJson(json['matiere'])
          : null,
    );
  }
}

class MatiereExamen {
  final int? id;
  final String? nomMatiere;
  final int? coefficient;

  MatiereExamen({this.id, this.nomMatiere, this.coefficient});

  factory MatiereExamen.fromJson(Map<String, dynamic> json) {
    return MatiereExamen(
      id: json['id'],
      nomMatiere: json['nom_matiere'],
      coefficient: json['coefficient'],
    );
  }
}
