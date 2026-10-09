class Justification {
  final int id;
  final List<MatiereDetail> detailsMatieres;
  final DateTime dateAbsenceDebut;
  final DateTime dateAbsenceFin;
  final String typeJustification;
  final String status;
  final DateTime createdAt;
  final String raison;
  final String commentaire;
  final String fileUrl;

  Justification({
    required this.id,
    required this.detailsMatieres,
    required this.dateAbsenceDebut,
    required this.dateAbsenceFin,
    required this.typeJustification,
    required this.status,
    required this.createdAt,
    required this.raison,
    required this.commentaire,
    required this.fileUrl,
  });

  factory Justification.fromJson(Map<String, dynamic> json) {
    // Parse detailsMatieres array
    List<MatiereDetail> matieres = [];
    if (json['detailsMatieres'] != null && json['detailsMatieres'] is List) {
      matieres = (json['detailsMatieres'] as List)
          .map((item) => MatiereDetail.fromJson(item))
          .toList();
    }

    return Justification(
      id: json['id'] ?? 0,
      detailsMatieres: matieres,
      dateAbsenceDebut:
          DateTime.tryParse(json['dateAbsenceDebut'] ?? '') ?? DateTime.now(),
      dateAbsenceFin:
          DateTime.tryParse(json['dateAbsenceFin'] ?? '') ?? DateTime.now(),
      typeJustification: json['typeJustification'] ?? '',
      status: json['status'] ?? 'En Attente',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      raison: json['raison'] ?? '',
      commentaire: json['commentaire'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
    );
  }

  static List<Justification> fromList(dynamic jsonData) {
    if (jsonData is List) {
      return jsonData.map((item) => Justification.fromJson(item)).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detailsMatieres': detailsMatieres.map((e) => e.toJson()).toList(),
      'dateAbsenceDebut': dateAbsenceDebut.toIso8601String(),
      'dateAbsenceFin': dateAbsenceFin.toIso8601String(),
      'typeJustification': typeJustification,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'raison': raison,
      'commentaire': commentaire,
      'fileUrl': fileUrl,
    };
  }

  // Helper method to get matiere names as a formatted string for display
  String get matiereNames {
    if (detailsMatieres.isEmpty) return 'Aucune matière';
    return detailsMatieres.map((m) => m.nom).join(', ');
  }

  // Helper method to get matiere IDs as a list
  List<int> get matiereIds {
    return detailsMatieres.map((m) => m.id).toList();
  }
}

class MatiereDetail {
  final int id;
  final String nom;

  MatiereDetail({required this.id, required this.nom});

  factory MatiereDetail.fromJson(Map<String, dynamic> json) {
    return MatiereDetail(id: json['id'] ?? 0, nom: json['nom'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nom': nom};
  }
}
