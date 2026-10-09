import 'dart:developer';

import 'package:admin/features/gestion_comptes/scolarite/cubit/scolarite_liste_state.dart';
import 'package:admin/features/gestion_comptes/scolarite/models/scolarite_model.dart';
import 'package:admin/features/gestion_comptes/scolarite/repo/scolarite_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScolariteCubit extends Cubit<ScolariteState> {
  final ScolariteRepo _repo;

  // Keeps the full list so we can restore it when query is cleared
  List<ScolariteModel> _allScolarites = [];

  ScolariteCubit(this._repo) : super(ScolariteInitial());

  // ─── Load full list (called on init and when search is cleared) ───────────
  Future<void> loadScolarites() async {
    emit(ScolariteLoading());
    final result = await _repo.getScolarites();
    result.fold(
      (error) {
        log('ERROR: $error');
        emit(ScolariteError(error));
      },
      (list) {
        emit(ScolariteLoaded(Scolarites: list));
      },
    );
  }

  // ─── Optimistic delete ────────────────────────────────────────────────────
  void removeLocally(String authId) {
    final current = state;
    if (current is! ScolariteLoaded) return;
    final updated = current.Scolarites.where(
      (e) => e.authId != authId,
    ).toList();
    _allScolarites = _allScolarites.where((e) => e.authId != authId).toList();
    emit(ScolariteLoaded(Scolarites: updated));
  }

  // ─── Rollback on failed delete/archive ───────────────────────────────────
  void rollback(ScolariteModel student) {
    final current = state;
    if (current is! ScolariteLoaded) return;
    _allScolarites = [..._allScolarites, student];
    emit(ScolariteLoaded(Scolarites: [...current.Scolarites, student]));
  }
}
