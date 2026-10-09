class ProfileModel {
  final String nom;
  final String prenom;
  final String photoUrl;
  final String willayaNaiss;
  final String dateNaissance;
  final String description;

  ProfileModel({
    required this.nom,
    required this.prenom,
    required this.photoUrl,
    required this.willayaNaiss,
    required this.dateNaissance,
    required this.description,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      willayaNaiss: json['willaya_naiss'] ?? '',
      dateNaissance: json['date_naissance'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
