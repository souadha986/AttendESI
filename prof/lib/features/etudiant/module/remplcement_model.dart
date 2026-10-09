class RemplacementModel {
  final String nom;
  final String prenom;
  final String authId; // Changed to camelCase to match Dart conventions

  RemplacementModel({
    required this.nom,
    required this.prenom,
    required this.authId,
  });

  // Factory to create a Student from JSON
  factory RemplacementModel.fromJson(Map<String, dynamic> json) {
    return RemplacementModel(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      // Ensure the key 'auth_id' matches exactly what the API returns
      authId: json['auth_id'] ?? '',
    );
  }

  // Good to have: Convert back to JSON for POST requests or local storage
  Map<String, dynamic> toJson() {
    return {'nom': nom, 'prenom': prenom, 'auth_id': authId};
  }
}
