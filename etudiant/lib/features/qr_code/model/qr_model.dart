class ScanRequestModel {
  final int seanceId;

  ScanRequestModel({required this.seanceId});

  Map<String, dynamic> toJson() => {'seanceId': seanceId};
}
