import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/features/planning/models/planning_models.dart';
class PlanningApi {
  final DioHelper dioHelper;

  PlanningApi(this.dioHelper);

  ///Planning (avec filtres)
  Future<Either<String, NormalPlanning>> getPlanning({
    String? niveau,
    String? specialite,
  }) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getPlanning,
        queryParameters: {
          if (niveau != null) "niveau": niveau.replaceAll(" ", ""),
          if (specialite != null) "specialite": specialite,
        },
      );

      if (response.statusCode == 200) {
        final planning = NormalPlanning.fromJson(response.data);
        return Right(planning);
      }

      return Left("Erreur lors de la récupération du planning.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }

      if (e.response?.statusCode == 403) {
        return Left(e.response?.data['message'] ??
            "Accès interdit à ce niveau.");
      }

      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }

      return Left("Erreur réseau. Vérifiez votre connexion.");
    } catch (e) {
      return Left("Erreur inattendue.");
    }
  }

  /// Examens (SANS filtres)
  Future<Either<String, ExamPlanning>> getExamens() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getExamens,
      );

      if (response.statusCode == 200) {
        final examens = ExamPlanning.fromJson(response.data);
        return Right(examens);
      }

      return Left("Erreur lors de la récupération des examens.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }

      if (e.response?.statusCode == 403) {
        return Left(
          e.response?.data['message'] ??
              "Accès interdit aux examens.",
        );
      }

      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }

      return Left("Erreur réseau. Vérifiez votre connexion.");
    } catch (e) {
      return Left("Erreur inattendue.");
    }
  }
}