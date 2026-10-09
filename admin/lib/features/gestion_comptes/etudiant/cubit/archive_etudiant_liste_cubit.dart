import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_liste_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Archeiveliste extends Cubit<EtudiantArcheive> {
  final EtudiantRepo _repo;
  List<EtudiantModel> _allEtudiants = []; // ✅ Add this

  Archeiveliste(this._repo) : super(EtudiantArcheiveInitial());

  Future<void> loadEtudiants() async {
    emit(EtudiantArcheiveLoading());
    final result = await _repo.getarchiveEtudiants();
    result.fold((error) => emit(EtudiantArcheiveError(error)), (list) {
      _allEtudiants = list; // ✅ Cache the full list
      emit(EtudiantArcheiveLoaded(etudiants: list));
    });
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(EtudiantArcheiveLoaded(etudiants: _allEtudiants)); // ✅ Now works
      return;
    }

    emit(EtudiantArcheiveLoading());
    final result = await _repo.searcharcheiveEtudiants(query.trim());
    result.fold(
      (error) => emit(EtudiantArcheiveError(error)),
      (list) => emit(EtudiantArcheiveLoaded(etudiants: list)),
    );
  }

  void removeLocally(String authId) {
    final current = state;
    if (current is! EtudiantArcheiveLoaded) return;
    _allEtudiants.removeWhere((e) => e.authId == authId);
    final updated = current.etudiants.where((e) => e.authId != authId).toList();
    emit(EtudiantArcheiveLoaded(etudiants: updated));
  }

  void rollback(EtudiantModel student) {
    final current = state;
    if (current is! EtudiantArcheiveLoaded) return;
    _allEtudiants.add(student); // ✅ Keep cache in sync
    emit(EtudiantArcheiveLoaded(etudiants: [...current.etudiants, student]));
  }
}
