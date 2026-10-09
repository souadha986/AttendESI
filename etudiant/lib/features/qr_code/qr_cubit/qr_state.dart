abstract class QrcodeState {}

class QrcodeInitial extends QrcodeState {}

class QrcodeLoading extends QrcodeState {}

class QrcodeSuccess extends QrcodeState {
  final String message;
  QrcodeSuccess(this.message);
}

class QrcodeError extends QrcodeState {
  final String error;
  QrcodeError(this.error);
}
