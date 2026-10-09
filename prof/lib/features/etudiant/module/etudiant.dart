class Etudiant {
  final String nom;
  final String prenom;
  final String authId;
  final String specialite;
  final String situation;
  final String groupe;
  final String matricule;

  Etudiant({
    required this.nom,
    required this.prenom,
    required this.authId,
    required this.specialite,
    required this.situation,
    required this.matricule,
    required this.groupe,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) => Etudiant(
    nom: json['nom']?.toString() ?? '',
    prenom: json['prenom']?.toString() ?? '',
    authId: json['auth_id']?.toString() ?? '',
    specialite: json['specialite']?.toString() ?? '',
    situation: json['situation']?.toString() ?? '',
    groupe: json['groupe']?.toString() ?? '',
    matricule: json['matricule']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'prenom': prenom,
    'auth_id': authId,
    'specialite': specialite,
    'situation': situation,
    'groupe': groupe,
    'matricule': matricule,
  };
}
