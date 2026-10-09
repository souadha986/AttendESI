class ProfileModel {
  final String nom;
  final String prenom;
  final String photoUrl;
  final String willayaNaiss;
  final String dateNaissance;
  final String situation;
  final int groupe;
  final String specialite;

  ProfileModel({
    required this.nom,
    required this.prenom,
    required this.photoUrl,
    required this.willayaNaiss,
    required this.dateNaissance,
    required this.situation,
    required this.groupe,
    required this.specialite,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      willayaNaiss: json['willaya_naiss'] ?? '',
      dateNaissance: json['date_naissance'] ?? '',
      situation: json['situation'] ?? '',
      groupe: json['groupe'] ?? 0,
      specialite: json['specialite'] ?? '',
    );
  }
}
