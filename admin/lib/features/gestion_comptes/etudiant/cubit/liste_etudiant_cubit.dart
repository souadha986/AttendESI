import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EtudiantCubit extends Cubit<EtudiantState> {
  final EtudiantRepo _repo;

  // Keeps the full list so we can restore it when query is cleared
  List<EtudiantModel> _allEtudiants = [];

  EtudiantCubit(this._repo) : super(EtudiantInitial());

  // ─── Load full list (called on init and when search is cleared) ───────────
  Future<void> loadEtudiants() async {
    emit(EtudiantLoading());
    final result = await _repo.getEtudiants();
    result.fold((error) => emit(EtudiantError(error)), (list) {
      _allEtudiants = list; // cache for rollback
      emit(EtudiantLoaded(etudiants: list));
    });
  }

  // ─── Called on every keystroke from the search field ─────────────────────
  Future<void> search(String query) async {
    // Empty query → restore full list without a loading flicker
    if (query.trim().isEmpty) {
      emit(EtudiantLoaded(etudiants: _allEtudiants));
      return;
    }

    emit(EtudiantLoading());
    final result = await _repo.searchEtudiants(query.trim());
    result.fold(
      (error) => emit(EtudiantError(error)),
      (list) => emit(EtudiantLoaded(etudiants: list)),
    );
  }

  // ─── Optimistic delete ────────────────────────────────────────────────────
  void removeLocally(String authId) {
    final current = state;
    if (current is! EtudiantLoaded) return;
    final updated = current.etudiants.where((e) => e.authId != authId).toList();
    _allEtudiants = _allEtudiants.where((e) => e.authId != authId).toList();
    emit(EtudiantLoaded(etudiants: updated));
  }

  // ─── Rollback on failed delete/archive ───────────────────────────────────
  void rollback(EtudiantModel student) {
    final current = state;
    if (current is! EtudiantLoaded) return;
    _allEtudiants = [..._allEtudiants, student];
    emit(EtudiantLoaded(etudiants: [...current.etudiants, student]));
  }
}
