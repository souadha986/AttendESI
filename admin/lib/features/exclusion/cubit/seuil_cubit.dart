import 'package:admin/features/exclusion/model/seuil_congif_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/features/exclusion/repo/exclusion_repo.dart';
import 'seuil_state.dart';

class SeuilCubit extends Cubit<SeuilState> {
  final ExclusionRepo _repo;

  SeuilCubit(this._repo) : super(SeuilInitial());

  // ── GET ─────────────────────────────────────────────────────────────────
  Future<void> loadSeuil() async {
    emit(SeuilLoading());
    final result = await _repo.getSeuil();
    result.fold(
      (error) => emit(SeuilError(error)),
      (model) => emit(SeuilLoaded(model)),
    );
  }

  // ── POST ────────────────────────────────────────────────────────────────
  Future<void> saveSeuil({
    required int seuil,
    required bool methode,
  }) async {
    // On garde le modèle courant pour l'afficher pendant la sauvegarde
    final current = _currentModel(seuil: seuil, methode: methode);
    emit(SeuilSaving(current));

    final result = await _repo.configurerSeuil(seuil: seuil, methode: methode);

    result.fold(
      (error) => emit(SeuilSaveError(current: current, message: error)),
      (message) => emit(
        SeuilSaved(
          updated: SeuilModel(seuil: seuil, methodeCalcule: methode),
          message: message,
        ),
      ),
    );
  }

  SeuilModel _currentModel({required int seuil, required bool methode}) {
    return SeuilModel(seuil: seuil, methodeCalcule: methode);
  }
}