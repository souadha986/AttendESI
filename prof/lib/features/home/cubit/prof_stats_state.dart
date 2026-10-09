import 'package:prof/features/home/models/absence_model.dart';

abstract class ProfStatsState {
  const ProfStatsState();
}

class ProfStatsInitial extends ProfStatsState {
  const ProfStatsInitial();
}

class ProfStatsLoading extends ProfStatsState {
  const ProfStatsLoading();
}

class ProfStatsSuccess extends ProfStatsState {
  final AbsenceModel stats;
  const ProfStatsSuccess(this.stats);
}

class ProfStatsError extends ProfStatsState {
  final String error;
  const ProfStatsError(this.error);
}
