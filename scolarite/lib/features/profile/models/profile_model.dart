class ProfileModel {
    String? nom_complet;
    String? email;
    String? role;
    String? etablissement;
    String? statut;
    List<String>? niveauxAutorises;
    String? cycleResponsable;

    ProfileModel({
        this.nom_complet,
        this.email,
        this.role,
        this.etablissement,
        this.statut,
        this.niveauxAutorises,
        this.cycleResponsable,
    });
   factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nom_complet: json['nom_complet'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      etablissement: json['etablissement'] ?? '',
      statut: json['statut'] ?? '',
      niveauxAutorises: List<String>.from(json['niveaux_autorises'] ?? []),
      cycleResponsable: json['cycle_responsable'] ?? '',
    );
  }
}

