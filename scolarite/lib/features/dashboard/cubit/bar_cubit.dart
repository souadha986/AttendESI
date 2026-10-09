import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/dashboard/models/dashboard_models.dart';
import 'package:scolarite/features/dashboard/repo/dashboard_repo.dart';
import 'bar_state.dart';

class BarCubit extends Cubit<BarState> {
  final DashboardRepo dashboardRepo;

  /// L'index du niveau sélectionné
  int selectedNiveauIndex = 0;

  /// Liste des niveaux disponibles (pour le dropdown)
  List<String> niveauxDisponibles = [];

  BarCubit(this.dashboardRepo) : super(BarInitial());

  /// Récupère le graphique d'absences pour un niveau donné
  Future<void> getGraphiqueAbsences({required String niveau}) async {
    emit(BarLoadingState());
    final Either<String, BarModel> res = await dashboardRepo
        .getGraphiqueAbsences(niveau: niveau);

    res.fold((left) => emit(BarErrorState(left)), (right) {
      // Mettre à jour la liste des niveaux disponibles si nécessaire
      niveauxDisponibles = right.niveauxDisponibles ?? [];
      emit(BarSuccessState(right));
    });
  }

  /// Met à jour le niveau sélectionné (appelé depuis le dropdown)
  Future<void> setSelectedNiveau(int index) async {
    if (index < 0 || index >= niveauxDisponibles.length) return;

    selectedNiveauIndex = index;
    final niveau = niveauxDisponibles[index];
    await getGraphiqueAbsences(niveau: niveau);
    // réémet l'état courant pour forcer la mise à jour du widget
    emit(state);
  }

  /// Récupère le niveau sélectionné actuel
  String get selectedNiveau => (selectedNiveauIndex < niveauxDisponibles.length)
      ? niveauxDisponibles[selectedNiveauIndex]
      : niveauxDisponibles.isNotEmpty
      ? niveauxDisponibles.first
      : "";

  /// Refresh - recharge avec niveau actuel ou premier disponible
 Future<void> refresh() async {
  final niveau = selectedNiveau.isNotEmpty ? selectedNiveau : '';
  if (niveau.isEmpty) return; // wait to be called with a real niveau
  await getGraphiqueAbsences(niveau: niveau);
}

void emitLoading() {
  emit(BarLoadingState());
}
}
