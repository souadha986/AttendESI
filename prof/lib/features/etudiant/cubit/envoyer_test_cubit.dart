import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/etudiant/cubit/envoyer_test_state.dart';
import 'package:prof/features/etudiant/module/Envoyer_test_remplacment_request.dart';
import 'package:prof/features/etudiant/module/Envoyer_test_request.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class EnvoyerTestCubit extends Cubit<EnvoyerTestState> {
  final MarquerAbsenceApi repository;
  EnvoyerTestCubit(this.repository) : super(const EnvoyerTestInitial());

  Future<void> envoyerTest({
    required String titre,
    required String niveau,
    required String specialite,
    required List<int> groupe,
    required int matiereId,
    required String date,
    required String heureDebut,
    required String heureFin,
    required String salle,
  }) async {
    emit(const EnvoyerTestLoading());
    final request = EnvoyerTestRequest(
      titre: titre,
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      matiereId: matiereId,
      date: date,
      heureDebut: heureDebut,
      heureFin: heureFin,
      salle: salle,
    );

    final result = await repository.envoyerTest(request);
    result.fold(
      (left) => emit(EnvoyerTestError(left)),
      (right) => emit(EnvoyerTestSuccess(right)),
    );
  }

  Future<void> envoyerTestRemplacement({
    required String titre,
    required String niveau,
    required String specialite,
    required List<int> groupe,
    required List<String> authids,
    required int matiereId,
    required String dateAbsence,
    required String dateRemplacement,
    required String heureDebut,
    required String heureFin,
    required String salle,
  }) async {
    emit(const EnvoyerTestLoading());

    final request = EnvoyerTestRemplacementRequest(
      titre: titre,
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      matiereId: matiereId,
      dateAbsence: dateAbsence,
      heureDebut: heureDebut,
      heureFin: heureFin,
      salle: salle,
      targetStudent: authids,
      dateRemplacement: dateRemplacement,
    );

    final result = await repository.envoyeRTestRemplacement(request);
    result.fold(
      (left) => emit(EnvoyerTestError(left)),
      (right) => emit(EnvoyerTestSuccess(right)),
    );
  }
}
