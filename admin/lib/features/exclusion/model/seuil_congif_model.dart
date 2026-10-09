class SeuilModel {
  final int seuil;
  final bool methodeCalcule;

  const SeuilModel({
    required this.seuil,
    required this.methodeCalcule,
  });

  factory SeuilModel.fromJson(Map<String, dynamic> json) {
    return SeuilModel(
      seuil: json['seuil'] as int,
      methodeCalcule: json['Methode_calcule'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'seuil': seuil,
        'methode': methodeCalcule,
      };
}