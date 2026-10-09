import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/exclusion/model/action_decision_model.dart';
import 'package:admin/features/exclusion/model/detail_model.dart';
import 'package:admin/features/exclusion/model/exclusion_table_model.dart';
import 'package:admin/features/exclusion/model/seuil_congif_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ExclusionRepo {
  final DioHelper dioHelper;
  ExclusionRepo(this.dioHelper);

  Future<Either<String, ExclusionTableModel>> getAlerteList() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.exclusionAlerteListe,
      );
      final model = ExclusionTableModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(model);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, DetailModel>> getDossier({
    required String authId,
    required String matiereId,
  }) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.exclusionDossier(authId, matiereId),
      );
      final model = DetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(model);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

 Future<Either<String, ActionDecisionModel>> prononcerExclusion({
  required String studentAuthId,
  required int matiereId,
}) async {
  try {
    final response = await dioHelper.postrequestwhithtoken(
      endpoints: EndPoints.prononcerExclusion,
      data: {'studentAuthId': studentAuthId, 'matiereId': matiereId},
      isTemporary: false,
    );
    final model = ActionDecisionModel.fromJson(
      response.data as Map<String, dynamic>, 
    );
    return Right(model);
  } on DioException catch (e) {
    final serverMessage =
        e.response?.data['message'] ?? "Problème de connexion au serveur";
    return Left(serverMessage);
  } catch (e) {
    return Left("Une erreur inattendue est survenue");
  }
}

Future<Either<String, ActionDecisionModel>> accorderDerogation({
  required String studentAuthId,
  required int matiereId,
}) async {
  try {
    final response = await dioHelper.postrequestwhithtoken(
      endpoints: EndPoints.accorderDerogation,
      data: {'studentAuthId': studentAuthId, 'matiereId': matiereId},
      isTemporary: false,
    );
    final model = ActionDecisionModel.fromJson(
      response.data as Map<String, dynamic>, 
    );
    return Right(model);
  } on DioException catch (e) {
    final serverMessage =
        e.response?.data['message'] ?? "Problème de connexion au serveur";
    return Left(serverMessage);
  } catch (e) {
    return Left("Une erreur inattendue est survenue");
  }
}

Future<Either<String, SeuilModel>> getSeuil() async {
  try {
    final response = await dioHelper.getrequest(
      endpoints: EndPoints.exclusionParametres,
    );
    final model = SeuilModel.fromJson(response.data as Map<String, dynamic>);
    return Right(model);
  } on DioException catch (e) {
    final serverMessage =
        e.response?.data['message'] ?? "Problème de connexion au serveur";
    return Left(serverMessage);
  } catch (e) {
    return Left("Une erreur inattendue est survenue");
  }
}

Future<Either<String, String>> configurerSeuil({
  required int seuil,
  required bool methode,
}) async {
  try {
    final response = await dioHelper.postrequestwhithtoken(
      endpoints: EndPoints.exclusionConfigurerSeuil,
      data: {'seuil': seuil, 'methode': methode},
      isTemporary: false,
    );
    final message =
        response.data['message'] as String? ?? "Configuration mise à jour.";
    return Right(message);
  } on DioException catch (e) {
    final serverMessage =
        e.response?.data['message'] ?? "Problème de connexion au serveur";
    return Left(serverMessage);
  } catch (e) {
    return Left("Une erreur inattendue est survenue");
  }
}


Future<Either<String, ExclusionTableModel>> searchEtudiants({
  required String query,
}) async {
  try {
    final response = await dioHelper.getrequest(
      endpoints: EndPoints.exclusionRecherche(query),
    );
    final model = ExclusionTableModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    return Right(model);
  } on DioException catch (e) {
    final serverMessage =
        e.response?.data['message'] ?? "Problème de connexion au serveur";
    return Left(serverMessage);
  } catch (e) {
    return Left("Une erreur inattendue est survenue");
  }
}
}