import 'dart:developer';

import 'package:admin/features/gestion_comptes/prof/cubit/cubit/liste_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfCubit extends Cubit<ProfState> {
  final ProfRepo _repo;

  // Keeps the full list so we can restore it when query is cleared
  List<ProfModel> _allProfs = [];

  ProfCubit(this._repo) : super(ProfInitial());

  // ─── Load full list (called on init and when search is cleared) ───────────
  Future<void> loadProfs() async {
    emit(ProfLoading());
    final result = await _repo.getprofs();
    result.fold(
      (error) {
        log('ERROR: $error'); // ADD THIS
        emit(ProfError(error));
      },
      (list) {
        _allProfs = list;
        log('Total profs: ${list.length}');
        for (final p in list) {
          log('${p.fullname} → modules raw: ${p.modules}');
        }
        emit(ProfLoaded(Profs: list));
      },
    );
  }

  // ─── Called on every keystroke from the search field ─────────────────────
  Future<void> search(String query) async {
    // Empty query → restore full list without a loading flicker
    if (query.trim().isEmpty) {
      emit(ProfLoaded(Profs: _allProfs));
      return;
    }

    emit(ProfLoading());
    final result = await _repo.searchprofs(query.trim());
    result.fold(
      (error) => emit(ProfError(error)),
      (list) => emit(ProfLoaded(Profs: list)),
    );
  }

  // ─── Optimistic delete ────────────────────────────────────────────────────
  void removeLocally(String authId) {
    final current = state;
    if (current is! ProfLoaded) return;
    final updated = current.Profs.where((e) => e.authId != authId).toList();
    _allProfs = _allProfs.where((e) => e.authId != authId).toList();
    emit(ProfLoaded(Profs: updated));
  }

  // ─── Rollback on failed delete/archive ───────────────────────────────────
  void rollback(ProfModel student) {
    final current = state;
    if (current is! ProfLoaded) return;
    _allProfs = [..._allProfs, student];
    emit(ProfLoaded(Profs: [...current.Profs, student]));
  }
}
