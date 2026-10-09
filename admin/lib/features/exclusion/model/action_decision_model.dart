class ActionDecisionModel {
  final String studentAuthId;
  final int matiereId;
  final String status; 

  ActionDecisionModel({
    required this.studentAuthId,
    required this.matiereId,
    required this.status,
  });
factory ActionDecisionModel.fromJson(Map<String, dynamic> json) {
  final data = json['data'] as Map<String, dynamic>? ?? json;
  return ActionDecisionModel(
    studentAuthId: data['studentAuthId'] as String? ?? '',
    matiereId: data['matiereId'] is int
        ? data['matiereId'] as int
        : int.tryParse(data['matiereId'].toString()) ?? 0,
    status: data['status'] as String? ?? '',
  );
}
}