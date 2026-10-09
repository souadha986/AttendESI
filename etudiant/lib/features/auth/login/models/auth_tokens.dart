class AuthTokens {
  final String accessToken;
  final String refreshToken;
  // ✅ Ajout des deux variables nécessaires pour les notifications
  final String niveau;
  final String specialite;
  final String groupe;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.niveau,
    required this.specialite,
    required this.groupe,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      // ✅ Extraction directe depuis l'objet 'user' du JSON
      niveau: json["niveau"] ?? "",
      specialite: json["specialite"] ?? "",
      groupe: json["group"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "niveau": niveau,
      "specialite": specialite,
    };
  }
}
