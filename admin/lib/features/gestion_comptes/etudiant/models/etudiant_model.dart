class EtudiantModel {
  final String nom;
  final String prenom;
  final String fullName;
  final String email;
  final String niveau;
  final String specialite;
  final int groupe;
  final String matricule;
  final String? authId;
  final bool maladieCr;
  final String? wilaya;
  final String? dateNaissance; // formatted as dd-MM-yyyy

  const EtudiantModel({
    required this.nom,
    required this.prenom,
    required this.fullName,
    required this.email,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.matricule,
    this.authId,
    required this.maladieCr,
    this.wilaya,
    this.dateNaissance,
  });
  factory EtudiantModel.fromJson(Map<String, dynamic> json) {
    return EtudiantModel(
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      niveau: json['situation'] as String? ?? '',
      specialite: json['specialite'] as String? ?? '',
      groupe: json['groupe'] as int? ?? 0,
      matricule: json['matricule'] as String? ?? '',
      authId: json['auth_id'] as String? ?? json['authId'] as String?,
      maladieCr: json['maladieCr'] as bool? ?? false,
      wilaya: json['willaya_naiss'] as String?,
      dateNaissance: _formatDate(json['date_naissance'] as String?),
    );
  }

  /// Converts any ISO date string (e.g. "2008-05-12" or "2008-05-12T00:00:00")
  /// to "12-05-2008". Returns null if the value is null or unparseable.
  static String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw);
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final yyyy = dt.year.toString();
      return '$dd-$mm-$yyyy';
    } catch (_) {
      return raw; // return as-is if format is unexpected
    }
  }

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'prenom': prenom,
    'fullName': fullName,
    'email': email,
    'niveau': niveau,
    'specialite': specialite,
    'groupe': groupe,
    'matricule': matricule,
    'authId': authId,
    'maladieCr': maladieCr,
    'willaya_naiss': wilaya,
    'date_naissance': dateNaissance,
  };
}
