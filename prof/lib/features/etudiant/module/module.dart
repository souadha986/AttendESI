class Module {
  final int id;
  final String nomMatiere;

  Module({required this.id, required this.nomMatiere});

  factory Module.fromJson(Map<String, dynamic> json) =>
      Module(id: json['id'], nomMatiere: json['nom_matiere']);

  Map<String, dynamic> toJson() => {'id': id, 'nom_matiere': nomMatiere};
}
