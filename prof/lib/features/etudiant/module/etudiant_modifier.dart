class EtudiantModifier {
  final String authId;
  final String matricule;
  final String nomComplet;
  String status; // mutable si tu veux changer "INDEFINI" après

  EtudiantModifier({
    required this.authId,
    required this.nomComplet,
    required this.status,
    required this.matricule,
  });

  // Factory pour créer un objet depuis un JSON
  factory EtudiantModifier.fromJson(Map<String, dynamic> json) {
    return EtudiantModifier(
      matricule: json['matricule'] as String,
      authId: json['authId'] as String,
      nomComplet: json['nomComplet'] as String,
      status: json['status'] as String,
    );
  }

  // Méthode pour convertir l'objet en JSON
  Map<String, dynamic> toJson() {
    return {'authId': authId, 'nomComplet': nomComplet, 'status': status};
  }
}
