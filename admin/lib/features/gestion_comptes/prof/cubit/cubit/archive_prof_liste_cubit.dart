import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_liste_state.dart';
import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';

import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArcheiveProfliste extends Cubit<ProfArcheive> {
  final ProfRepo _repo;
  List<ProfModel> _allProfs = []; // ✅ Add this

  ArcheiveProfliste(this._repo) : super(ProfArcheiveInitial());

  Future<void> loadProfs() async {
    emit(ProfArcheiveLoading());
    final result = await _repo.getarchiveprofs();
    result.fold((error) => emit(ProfArcheiveError(error)), (list) {
      _allProfs = list; // ✅ Cache the full list
      emit(ProfArcheiveLoaded(Profs: list));
    });
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(ProfArcheiveLoaded(Profs: _allProfs)); // ✅ Now works
      return;
    }

    emit(ProfArcheiveLoading());
    final result = await _repo.searcharcheiveprofs(query.trim());
    result.fold(
      (error) => emit(ProfArcheiveError(error)),
      (list) => emit(ProfArcheiveLoaded(Profs: list)),
    );
  }

  void removeLocally(String authId) {
    final current = state;
    if (current is! ProfArcheiveLoaded) return;
    _allProfs.removeWhere((e) => e.authId == authId); // ✅ Keep cache in sync
    final updated = current.Profs.where((e) => e.authId != authId).toList();
    emit(ProfArcheiveLoaded(Profs: updated));
  }

  void rollback(ProfModel student) {
    final current = state;
    if (current is! ProfArcheiveLoaded) return;
    _allProfs.add(student); // ✅ Keep cache in sync
    emit(ProfArcheiveLoaded(Profs: [...current.Profs, student]));
  }
}
