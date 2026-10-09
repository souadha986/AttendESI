class JustificatifsModel {
    int? id;
    String? nomEtudiant;
    String? email;
    String? niveau;
    List<String>? modules;
    DateTime? dateAbsenceDebut;
    DateTime? dateAbsenceFin;
    DateTime? dateSoumission;
    String? type;
    String? status;
    String? commentaire;

    JustificatifsModel({
        this.id,
        this.nomEtudiant,
        this.email,
        this.niveau,
        this.modules,
        this.dateAbsenceDebut,
        this.dateAbsenceFin,
        this.dateSoumission,
        this.type,
        this.status,
        this.commentaire,
    });

  factory JustificatifsModel.fromJson(Map<String, dynamic> json) =>
    JustificatifsModel(
      id: json["id"],
      nomEtudiant: json["nom_etudiant"], 
      email: json["email"],
      niveau: json["niveau"],
      modules: json["modules"] != null
          ? List<String>.from(json["modules"].map((x) => x))
          : [],
      dateAbsenceDebut: json["date_absence_debut"] != null
          ? DateTime.parse(json["date_absence_debut"])
          : null,
      dateAbsenceFin: json["date_absence_fin"] != null
          ? DateTime.parse(json["date_absence_fin"])
          : null,
      dateSoumission: json["date_soumission"] != null
          ? DateTime.parse(json["date_soumission"])
          : null,
      type: json["type"],
      status: json["status"],
      commentaire: json["commentaire"],
    );

}

class JustificatifDetails {
    int? id;
    Etudiant? etudiant;
    Absence? absence;
    String? description;
    String? documentUrl;
    String? status;
    String? commentaire;

    JustificatifDetails({
        this.id,
        this.etudiant,
        this.absence,
        this.description,
        this.documentUrl,
        this.status,
        this.commentaire,
    });
   factory JustificatifDetails.fromJson(Map<String, dynamic> json) {
    return JustificatifDetails(
      id: json['id'],
      etudiant: json['etudiant'] != null
          ? Etudiant.fromJson(json['etudiant'])
          : null,
      absence: json['absence'] != null
          ? Absence.fromJson(json['absence'])
          : null,
      description: json['description'],
      documentUrl: json['document_url'],
      status: json['status'],
      commentaire: json['commentaire'],
    );
  }  

}

class Absence {
    List<String>? modules;
    String? type;
    DateTime? dateAbsenceDebut;
    DateTime? dateAbsenceFin;
    DateTime? dateSoumission;

    Absence({
        this.modules,
        this.type,
        this.dateAbsenceDebut,
        this.dateAbsenceFin,
        this.dateSoumission,
    });
     factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      modules: json['modules'] != null
          ? List<String>.from(json['modules'])
          : [],
      type: json['type'],
      dateAbsenceDebut: json['date_absence_debut'] != null
          ? DateTime.parse(json['date_absence_debut'])
          : null,
      dateAbsenceFin: json['date_absence_fin'] != null
          ? DateTime.parse(json['date_absence_fin'])
          : null,
      dateSoumission: json['date_soumission'] != null
          ? DateTime.parse(json['date_soumission'])
          : null,
    );
  }

}

class Etudiant {
    String? nomComplet;
    String? email;
    String? niveau;
    bool? maladieChronique;

    Etudiant({
        this.nomComplet,
        this.email,
        this.niveau,
        this.maladieChronique,
    });
      factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      nomComplet: json['nom_complet'],
      email: json['email'],
      niveau: json['niveau'],
      maladieChronique: json['maladie_chronique'],
    );
  }

}

class JustificatifTraitement {
    int? id;
    List<int>? matiereIds;
    DateTime? dateAbsenceDebut;
    DateTime? dateAbsenceFin;
    String? typeJustification;
    String? raison;
    String? fileUrl;
    String? status;
    String? studentAuthId;
    String? commentaire;
    DateTime? createdAt;

    JustificatifTraitement({
        this.id,
        this.matiereIds,
        this.dateAbsenceDebut,
        this.dateAbsenceFin,
        this.typeJustification,
        this.raison,
        this.fileUrl,
        this.status,
        this.studentAuthId,
        this.commentaire,
        this.createdAt,
    });

    factory JustificatifTraitement.fromJson(Map<String, dynamic> json) {
    return JustificatifTraitement(
      id: json['id'],
      matiereIds: json['matiereIds'] != null
          ? List<int>.from(json['matiereIds'])
          : [],
      dateAbsenceDebut: json['dateAbsenceDebut'] != null
          ? DateTime.parse(json['dateAbsenceDebut'])
          : null,
      dateAbsenceFin: json['dateAbsenceFin'] != null
          ? DateTime.parse(json['dateAbsenceFin'])
          : null,
      typeJustification: json['typeJustification'],
      raison: json['raison'],
      fileUrl: json['fileUrl'],
      status: json['status'], 
      studentAuthId: json['studentAuthId'],
      commentaire: json['commentaire'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

}
