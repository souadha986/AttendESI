class ProfModel {
  final int idProf;
  final String authId;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String? description;
  final String? willayaNaiss;
  final DateTime? dateNaissance;
  final String? fcmToken;
  final String fullname;
  final String? modules;

  ProfModel({
    required this.idProf,
    required this.authId,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.description,
    this.willayaNaiss,
    this.dateNaissance,
    this.fcmToken,
    required this.fullname,
    this.modules,
  });

  factory ProfModel.fromJson(Map<String, dynamic> json) => ProfModel(
    idProf: json['id_prof'],
    authId: json['auth_id'] ?? '',
    nom: json['nom'],
    prenom: json['prenom'],
    email: json['email'],
    role: json['role'] ?? '',
    description: json['description'],
    willayaNaiss: json['willaya_naiss'],
    dateNaissance: json['date_naissance'] != null
        ? DateTime.parse(json['date_naissance'])
        : null,
    fcmToken: json['fcmToken'],
    fullname: json['fullname'],

    modules: _parseModules(json['modules']),
  );

  static String? _parseModules(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) {
      final joined = raw.map((e) => e.toString()).join(', ');
      return joined.isEmpty ? null : joined;
    }
    if (raw is String) return raw.isEmpty ? null : raw;
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id_prof': idProf,
    'auth_id': authId,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'role': role,
    'description': description,
    'willaya_naiss': willayaNaiss,
    'date_naissance': dateNaissance?.toIso8601String(),
    'fcmToken': fcmToken,
    'fullname': fullname,
    'modules': modules,
  };

  // ✅ Split by comma not newline
  List<String> get modulesList =>
      modules
          ?.split(',')
          .map((m) => m.trim())
          .where((m) => m.isNotEmpty)
          .toList() ??
      [];
}
