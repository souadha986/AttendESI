import 'package:admin/features/tableau_board/model/tableau_bord_model.dart';

abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartSuccess extends ChartState {
  final List<ChartModel> chart;
  ChartSuccess(this.chart);
}

class ChartError extends ChartState {
  final String error;
  ChartError(this.error);
}