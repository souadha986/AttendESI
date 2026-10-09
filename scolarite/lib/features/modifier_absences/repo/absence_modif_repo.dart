import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';

class AbsenceModifApi {
  final DioHelper dioHelper;

  AbsenceModifApi(this.dioHelper);

  Future<Either<String, AbsenceModifModels>> getAbsences() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getAbsences,
      );

      if (response.statusCode == 200) {
        final data = AbsenceModifModels.fromJson(response.data);
        return Right(data);
      }

      return Left("Erreur lors de la récupération des absences.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Token manquant ou session expirée.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
  Future<Either<String, ModifListeModel>> getModifListe(int absenceId) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getModifListe(absenceId),
      );

      if (response.statusCode == 200) {
        final data = ModifListeModel.fromJson(response.data);
        return Right(data);
      }

      return Left("Erreur lors de la récupération des détails.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Token manquant ou session expirée.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    }
  }

  //////////////////////////////////////////////////////////////////////
  Future<Either<String, ModifAbsenceResponse>> modifierAbsences({
    required int absenceId,
    required ModifAbsence body,
  }) async {
    try {
      final response = await dioHelper.patchrequest(
        endpoints: EndPoints.ModifAbsences(absenceId),
        data: body.toJson(),
       
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ModifAbsenceResponse.fromJson(response.data);
        return Right(data);
      }

      return Left("Erreur lors de la modification des absences.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Token manquant ou session expirée.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    }
  }
}
