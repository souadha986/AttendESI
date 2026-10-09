import 'package:admin/features/tableau_board/cubit/chart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/features/tableau_board/repo/tableau_bord_api.dart';


class ChartCubit extends Cubit<ChartState> {
  ChartCubit(this.api) : super(ChartInitial());

  final TableauBordApi api;

  String selectedNiveau = '';
  String selectedSpecialite = '';

 Future<void> getChart({
  required String niveau,
  String? specialite,
}) async {
  emit(ChartLoading());

  final result = await api.getChart(
    niveau: niveau,
    specialite: specialite, // peut être null
  );

  result.fold(
  (error) => emit(ChartError(error)),
  (data) {
    // même si vide → SUCCESS obligatoire
    emit(ChartSuccess(data));
  },
);
}
}