class ExclusionTableModel {
  final ConfigGenerale? configGenerale;
  final List<EtudiantEnAlerteModel>? etudiantsEnAlerte;

  const ExclusionTableModel({
    this.configGenerale,
    this.etudiantsEnAlerte,
  });

  factory ExclusionTableModel.fromJson(Map<String, dynamic> json) {
    return ExclusionTableModel(
      configGenerale: json['configGenerale'] != null
          ? ConfigGenerale.fromJson(json['configGenerale'] as Map<String, dynamic>)
          : null,
      etudiantsEnAlerte: (json['etudiantsEnAlerte'] as List<dynamic>?)
          ?.map((e) => EtudiantEnAlerteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'configGenerale': configGenerale?.toJson(),
        'etudiantsEnAlerte': etudiantsEnAlerte?.map((e) => e.toJson()).toList(),
      };
}

class ConfigGenerale {
  const ConfigGenerale();

  factory ConfigGenerale.fromJson(Map<String, dynamic> json) {
    return const ConfigGenerale();
  }

  Map<String, dynamic> toJson() => {};
}

class EtudiantEnAlerteModel {
  final String? authId;
  final String? nom;
  final String? prenom;
  final String? niveau;
  final String? specialite;
  final int? groupe;
  final String? module;
  final int? matiereId;
  final int? nbAbsences;
  final bool? maladeCr;
  final String? enseignant;
  final String? statut;

  const EtudiantEnAlerteModel({
    this.authId,
    this.nom,
    this.prenom,
    this.niveau,
    this.specialite,
    this.groupe,
    this.module,
    this.matiereId,
    this.nbAbsences,
    this.maladeCr,
    this.enseignant,
    this.statut,
  });

  factory EtudiantEnAlerteModel.fromJson(Map<String, dynamic> json) {
    return EtudiantEnAlerteModel(
      authId: json['authId'] as String?,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      niveau: json['niveau'] as String?,
      specialite: json['specialite'] as String?,
      groupe: json['groupe'] as int?,
      module: json['module'] as String?,
      matiereId: json['matiereId'] as int?,
      nbAbsences: json['nbAbsences'] as int?,
      maladeCr: json['maladeCr'] as bool?,
      enseignant: json['Enseignant'] as String?,
      statut: json['statut'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'authId': authId,
        'nom': nom,
        'prenom': prenom,
        'niveau': niveau,
        'specialite': specialite,
        'groupe': groupe,
        'module': module,
        'matiereId': matiereId,
        'nbAbsences': nbAbsences,
        'maladeCr': maladeCr,
        'Enseignant': enseignant,
        'statut': statut,
      };
}