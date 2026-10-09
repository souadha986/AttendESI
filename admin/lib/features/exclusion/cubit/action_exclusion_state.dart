import 'package:admin/features/exclusion/model/action_decision_model.dart';

abstract class ActionExclusionState {}

class ActionExclusionInitial extends ActionExclusionState {}

class PrononcerExclusionLoading extends ActionExclusionState {}

class PrononcerExclusionSuccess extends ActionExclusionState {
  final ActionDecisionModel decision; 
  PrononcerExclusionSuccess(this.decision);
}

class PrononcerExclusionError extends ActionExclusionState {
  final String message;
  PrononcerExclusionError(this.message);
}

class AccorderDerogationLoading extends ActionExclusionState {}

class AccorderDerogationSuccess extends ActionExclusionState {
  final ActionDecisionModel decision; 
  AccorderDerogationSuccess(this.decision);
}

class AccorderDerogationError extends ActionExclusionState {
  final String message;
  AccorderDerogationError(this.message);
}