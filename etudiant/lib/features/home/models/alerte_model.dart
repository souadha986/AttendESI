class AlertModel {
  final int alertId;
  final String matiereName;
  final int currentAbsences;
  final int maxAllowed;
  final String message;

  AlertModel({
    required this.alertId,
    required this.matiereName,
    required this.currentAbsences,
    required this.maxAllowed,
    required this.message,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      alertId: json['alertId'],
      matiereName: json['matiereName'],
      currentAbsences: json['currentAbsences'],
      maxAllowed: json['maxAllowed'],
      message: json['message'],
    );
  }
}
