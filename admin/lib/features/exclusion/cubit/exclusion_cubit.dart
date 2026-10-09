import 'dart:async';

import 'package:admin/features/exclusion/cubit/exclusion_state.dart';
import 'package:admin/features/exclusion/model/exclusion_table_model.dart';
import 'package:admin/features/exclusion/repo/exclusion_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExclusionCubit extends Cubit<ExclusionState> {
  final ExclusionRepo _repo;

  ExclusionLoaded? _lastLoaded;

  ExclusionCubit(this._repo) : super(ExclusionInitial());

  // ── Liste des alertes ────────────────────────────────────────────────────

  Future<void> loadAlerteList() async {
    emit(ExclusionLoading());
    final result = await _repo.getAlerteList();
    result.fold(
      (error) => emit(ExclusionError(error)),
      (data) {
        _lastLoaded = ExclusionLoaded(
          etudiants: data.etudiantsEnAlerte ?? [],
        );
        emit(_lastLoaded!);
      },
    );
  }

 void search(String query) {
  if (query.trim().isEmpty) {
    if (_lastLoaded != null) emit(_lastLoaded!);
    return;
  }
  _doSearch(query.trim());
}

Future<void> _doSearch(String query) async {
  emit(ExclusionSearching());
  final result = await _repo.searchEtudiants(query: query);
  result.fold(
    (error) => emit(ExclusionSearchError(error)),
    (data) => emit(ExclusionSearchLoaded(data.etudiantsEnAlerte ?? [])),
  );
}
  // ── Dossier détaillé ────────────────────────────────────────────────────

  Future<void> loadDossier({
    required String authId,
    required String matiereId,
  }) async {
    emit(DossierLoading());
    final result = await _repo.getDossier(
      authId: authId,
      matiereId: matiereId,
    );
    result.fold(
      (error) => emit(DossierError(error)),
      (data) => emit(DossierLoaded(data)),
    );
  }

  // ── Patch local du statut après action ──────────────────────────────────

 void updateStatutLocal({
  required String authId,
  required int matiereId,
  required String newStatut,
}) {
  final current = _lastLoaded;
  if (current == null) { return; }
  final updatedList = current.etudiants.map((e) {
    final sameAuth = e.authId == authId;
    final sameMatiere = e.matiereId?.toString() == matiereId.toString();
    if (sameAuth && sameMatiere) { 
      return EtudiantEnAlerteModel(
        authId: e.authId,
        nom: e.nom,
        prenom: e.prenom,
        niveau: e.niveau,
        specialite: e.specialite,
        groupe: e.groupe,
        module: e.module,
        matiereId: e.matiereId,
        nbAbsences: e.nbAbsences,
        maladeCr: e.maladeCr,
        enseignant: e.enseignant,
        statut: newStatut,
      );
    }
    return e;
  }).toList();

  _lastLoaded = ExclusionLoaded(etudiants: updatedList);
  emit(_lastLoaded!);
}
  // ── Revenir à la liste après fermeture du dialog ─────────────────────────

  void backToList() {
    if (_lastLoaded != null) emit(_lastLoaded!);
  }
}