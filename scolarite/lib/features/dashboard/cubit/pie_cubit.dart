import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/dashboard/models/dashboard_models.dart';
import 'package:scolarite/features/dashboard/repo/dashboard_repo.dart';
import 'pie_state.dart';

class PieCubit extends Cubit<PieState> {
  PieCubit(this.dashboardRepo) : super(PieInitial());

  final DashboardRepo dashboardRepo;

  PieModel? normaleData;
  PieModel? examenData;

  int selectedIndex = 0;

  /// Change la session et récupère les données correspondantes
  void changeSession(int index) async {
    selectedIndex = index;

    final typeSeance = (index == 0) ? "SEANCE_NORMALE" : "EXAMEN";

    emit(PieLoadingState());

    final res = await dashboardRepo.getGraphiqueJustification(
      typeSeance: typeSeance,
    );

    res.fold(
      (error) => emit(PieErrorState(error)),
      (data) {
        if (index == 0) {
          normaleData = data;
        } else {
          examenData = data;
        }

        emit(PieSuccessState(
          normale: normaleData,
          examen: examenData,
        ));
      },
    );
  }

  /// Charger les deux sessions
  Future<void> loadAll() async {
    await getGraphiqueJustification(typeSeance: "SEANCE_NORMALE");
    await getGraphiqueJustification(typeSeance: "EXAMEN");
  }

  /// Récupération spécifique sans changer la session
  Future<void> getGraphiqueJustification({required String typeSeance}) async {
    if (normaleData == null && examenData == null) {
      emit(PieLoadingState());
    }

    final res = await dashboardRepo.getGraphiqueJustification(
      typeSeance: typeSeance.trim(),
    );

    res.fold(
      (error) => emit(PieErrorState(error)),
      (data) {
        if (typeSeance == "SEANCE_NORMALE") {
          normaleData = data;
        } else {
          examenData = data;
        }

        emit(PieSuccessState(
          normale: normaleData,
          examen: examenData,
        ));
      },
    );
  }

  /// Refresh complet
  Future<void> refresh() async {
    normaleData = null;
    examenData = null;

    emit(PieLoadingState());

    await loadAll();
  }
}