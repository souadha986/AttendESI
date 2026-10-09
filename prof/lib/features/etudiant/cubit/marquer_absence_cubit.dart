import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/etudiant/cubit/marquer_absence_state.dart';

import 'package:prof/features/etudiant/module/modifier_absence_request.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';
import 'package:prof/features/etudiant/module/marquer_absence_request.dart';

class MarquerAbsenceCubit extends Cubit<MarquerAbsenceState> {
  final MarquerAbsenceApi repository;

  MarquerAbsenceCubit(this.repository) : super(const MarquerAbsenceInitial());

  Future<void> submitAbsences({
    required int matiereId,
    required String date,
    required String time,
    required String niveau,
    required String specialite,
    required int groupe,
    required List<String> absents,
    required List<String> presents,
  }) async {
    emit(const MarquerAbsenceLoading());

    final request = MarquerAbsenceRequest(
      heureDebut: time,
      matiereId: matiereId,
      date: date,
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      absents: absents,
      presents: presents,
    );

    final result = await repository.marquerAbsences(request);
    result.fold(
      (left) => emit(MarquerAbsenceError(left)),
      (right) => emit(MarquerAbsenceSuccess(right)),
    );
  }

  Future<void> modifierAbsence({
    required int matiereId,
    required String date,
    required String heure,
    required String niveau,
    required String specialite,
    required int groupe,
    required List<String> absents,
    required List<String> presents,
  }) async {
    emit(const MarquerAbsenceLoading());

    final request = ModifierAbsenceRequest(
      heureDebut: heure,
      matiereId: matiereId,
      dateStr: date,
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      absents: absents,
      presents: presents,
    );

    final result = await repository.modifierAbsences(request);
    result.fold(
      (left) => emit(MarquerAbsenceError(left)),
      (right) => emit(MarquerAbsenceSuccess(right)),
    );
  }
}
