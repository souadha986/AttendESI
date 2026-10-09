class CardsModel {
  Utilisateur? utilisateur;
  String? cycleResponsable;
  List<String>? niveauxAutorises;
  List<String>? niveauxSuperieur;
  List<dynamic>? niveauxPreparatoire;
  int? absencesAujourdhui;
  String? variationHier;
  String? tauxAbsenceGlobal;
  String? variationMois;
  int? justificatifsEnAttente;
  CycleSuperieur? cycleSuperieur;
  dynamic cyclePreparatoire;

  CardsModel({
    this.utilisateur,
    this.cycleResponsable,
    this.niveauxAutorises,
    this.niveauxSuperieur,
    this.niveauxPreparatoire,
    this.absencesAujourdhui,
    this.variationHier,
    this.tauxAbsenceGlobal,
    this.variationMois,
    this.justificatifsEnAttente,
    this.cycleSuperieur,
    this.cyclePreparatoire,
  });
  factory CardsModel.fromJson(Map<String, dynamic> json) {
    return CardsModel(
      utilisateur: json['utilisateur'] != null
          ? Utilisateur.fromJson(json['utilisateur'])
          : null,
      cycleResponsable: json['cycle_responsable'] ?? '',
      niveauxAutorises: List<String>.from(json['niveaux_autorises'] ?? []),
      niveauxSuperieur: List<String>.from(json['niveaux_superieur'] ?? []),
      niveauxPreparatoire: List<dynamic>.from(
        json['niveaux_preparatoire'] ?? [],
      ),
      absencesAujourdhui: json['absences_aujourdhui'] ?? 0,
      variationHier: json['variation_hier'] ?? '',
      tauxAbsenceGlobal: json['taux_absence_global'] ?? '',
      variationMois: json['variation_mois'] ?? '',
      justificatifsEnAttente: json['justificatifs_en_attente'] ?? 0,
      cycleSuperieur: json['cycle_superieur'] != null
          ? CycleSuperieur.fromJson(json['cycle_superieur'])
          : null,
      cyclePreparatoire: json['cycle_preparatoire'],
    );
  }
}

class CycleSuperieur {
  List<String>? niveaux;
  int? nbEtudiants;
  int? totalAbsences;
  int? absencesAujourdhui;
  String? tauxAbsence;
  int? justificatifsValides;
  int? justificatifsEnAttente;
  List<DetailParNiveau>? detailParNiveau;

  CycleSuperieur({
    this.niveaux,
    this.nbEtudiants,
    this.totalAbsences,
    this.absencesAujourdhui,
    this.tauxAbsence,
    this.justificatifsValides,
    this.justificatifsEnAttente,
    this.detailParNiveau,
  });

  factory CycleSuperieur.fromJson(Map<String, dynamic> json) {
    return CycleSuperieur(
      niveaux: List<String>.from(json['niveaux'] ?? []),
      nbEtudiants: json['nb_etudiants'] ?? 0,
      totalAbsences: json['total_absences'] ?? 0,
      absencesAujourdhui: json['absences_aujourdhui'] ?? 0,
      tauxAbsence: json['taux_absence'] ?? '',
      justificatifsValides: json['justificatifs_valides'] ?? 0,
      justificatifsEnAttente: json['justificatifs_en_attente'] ?? 0,
      detailParNiveau:
          (json['detail_par_niveau'] as List?)
              ?.map((e) => DetailParNiveau.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DetailParNiveau {
  String? niveau;
  int? nbEtudiants;
  int? totalAbsences;
  int? absencesAujourdhui;
  String? tauxAbsence;
  int? justificatifsEnAttente;

  DetailParNiveau({
    this.niveau,
    this.nbEtudiants,
    this.totalAbsences,
    this.absencesAujourdhui,
    this.tauxAbsence,
    this.justificatifsEnAttente,
  });
  factory DetailParNiveau.fromJson(Map<String, dynamic> json) {
    return DetailParNiveau(
      niveau: json['niveau'] ?? '',
      nbEtudiants: json['nb_etudiants'] ?? 0,
      totalAbsences: json['total_absences'] ?? 0,
      absencesAujourdhui: json['absences_aujourdhui'] ?? 0,
      tauxAbsence: json['taux_absence'] ?? '',
      justificatifsEnAttente: json['justificatifs_en_attente'] ?? 0,
    );
  }
}

class Utilisateur {
  String? nom;
  String? prenom;

  Utilisateur({this.nom, this.prenom});
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(nom: json['nom'] ?? '', prenom: json['prenom'] ?? '');
  }
}

class BarModel {
  String? niveauFiltre;
  List<String>? niveauxDisponibles;
  int? totalAbsences;
  List<GraphiqueAbsence>? graphiqueAbsences;

  BarModel({
    this.niveauFiltre,
    this.niveauxDisponibles,
    this.totalAbsences,
    this.graphiqueAbsences,
  });
  factory BarModel.fromJson(Map<String, dynamic> json) {
    return BarModel(
      niveauFiltre: json['niveau_filtre'] ?? '',
      niveauxDisponibles: List<String>.from(json['niveaux_disponibles'] ?? []),
      totalAbsences: json['total_absences'] ?? 0,
      graphiqueAbsences:
          (json['graphique_absences'] as List?)
              ?.map((e) => GraphiqueAbsence.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class GraphiqueAbsence {
  String? matiere;
  int? count;
  String? pourcentage;

  GraphiqueAbsence({this.matiere, this.count, this.pourcentage});
  factory GraphiqueAbsence.fromJson(Map<String, dynamic> json) {
    return GraphiqueAbsence(
      matiere: json['matiere'] ?? '',
      count: json['count'] ?? 0,
      pourcentage: json['pourcentage'] ?? '',
    );
  }
}

class PieModel {
  String? typeSeanceFiltre;
  List<String>? typesDisponibles;
  int? totalAbsences;
  int? totalJustificatifs;
  GraphiqueJustification? graphiqueJustification;

  PieModel({
    this.typeSeanceFiltre,
    this.typesDisponibles,
    this.totalJustificatifs,
    this.totalAbsences,
    this.graphiqueJustification,
  });
  factory PieModel.fromJson(Map<String, dynamic> json) {
    return PieModel(
      typeSeanceFiltre: json['type_seance_filtre'] ?? '',
      typesDisponibles: List<String>.from(json['types_disponibles'] ?? []),
      totalAbsences: json['total_absences'] ?? 0,
      totalJustificatifs: json['total_justificatifs'] ?? 0,
      graphiqueJustification: json['graphique_justification'] != null
          ? GraphiqueJustification.fromJson(json['graphique_justification'])
          : null,
    );
  }
}

class GraphiqueJustification {
  int? valide;
  int? enAttente;
  int? rejete;
  int? nonJustifie;

  GraphiqueJustification({
    this.valide,
    this.enAttente,
    this.rejete,
    this.nonJustifie,
  });
  factory GraphiqueJustification.fromJson(Map<String, dynamic> json) {
    return GraphiqueJustification(
      valide: json['justifie'] ?? 0,
      enAttente: json['en_attente'] ?? 0,
      rejete: json['refuse'] ?? 0,
      nonJustifie: json['non_justifie'] ?? 0,
    );
  }
}
