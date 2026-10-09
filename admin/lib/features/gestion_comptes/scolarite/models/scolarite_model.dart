class ScolariteModel {
  final String authId;
  final String nom;
  final String prenom;
  final String email;
  final String cycleResponsable;

  ScolariteModel({
    required this.authId,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.cycleResponsable,
  });

  factory ScolariteModel.fromJson(Map<String, dynamic> json) => ScolariteModel(
    authId: json['auth_id'] ?? '',
    nom: json['nom'] ?? '',
    prenom: json['prenom'] ?? '',
    email: json['email'] ?? '',
    cycleResponsable: json['cycle_responsable'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'auth_id': authId,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'cycle_responsable': cycleResponsable,
  };

  String get fullname => '$nom $prenom';
}
