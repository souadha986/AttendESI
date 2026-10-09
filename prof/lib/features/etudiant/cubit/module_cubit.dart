import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/etudiant/cubit/module_state.dart';
import 'package:prof/features/etudiant/module/module.dart';

import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class ModuleCubit extends Cubit<ModuleState> {
  final MarquerAbsenceApi repo;
  ModuleCubit(this.repo) : super(Moduleinitailstate());
  Future<void> getmodule({
    required String specialite,
    required String niveau,
    required String groupe,
  }) async {
    emit(ModuleLoading());
    final Either<String, List<Module>> res = await repo.fetchModule(
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
    );
    res.fold(
      (left) => emit(ModuleError(left)),
      (right) => emit(ModuleLoaded(right)),
    );
  }

  Future<void> getmoduletest({
    required String specialite,
    required String niveau,
    required List<String> groupe,
  }) async {
    emit(ModuleLoading());
    final Either<String, List<Module>> res = await repo.fetchModuleTest(
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
    );
    res.fold(
      (left) => emit(ModuleError(left)),
      (right) => emit(ModuleLoaded(right)),
    );
  }
}
