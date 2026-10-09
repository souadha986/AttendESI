abstract class EnvoyerTestState {
  const EnvoyerTestState();
}

class EnvoyerTestInitial extends EnvoyerTestState {
  const EnvoyerTestInitial();
}

class EnvoyerTestLoading extends EnvoyerTestState {
  const EnvoyerTestLoading();
}

class EnvoyerTestSuccess extends EnvoyerTestState {
  final String success;
  const EnvoyerTestSuccess(this.success);
}

class EnvoyerTestError extends EnvoyerTestState {
  final String error;
  const EnvoyerTestError(this.error);
}
