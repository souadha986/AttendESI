abstract class GenerateQrState {}

class GenerateQrInitial extends GenerateQrState {}

class GenerateQrLoading extends GenerateQrState {}

class GenerateQrSuccess extends GenerateQrState {
  final String qrData;
  GenerateQrSuccess(this.qrData);
}

class GenerateQrError extends GenerateQrState {
  final String error;
  GenerateQrError(this.error);
}
