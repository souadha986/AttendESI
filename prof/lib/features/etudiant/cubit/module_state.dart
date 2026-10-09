import 'package:prof/features/etudiant/module/module.dart';

abstract class ModuleState {}

class Moduleinitailstate extends ModuleState {}

class ModuleLoading extends ModuleState {}

class ModuleLoaded extends ModuleState {
  final List<Module> modules;
  ModuleLoaded(this.modules);
}

class ModuleError extends ModuleState {
  final String error;
  ModuleError(this.error);
}
