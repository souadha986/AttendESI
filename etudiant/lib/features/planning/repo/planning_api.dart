import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';
import 'package:etudiant/features/planning/models/examen_model.dart';
import 'package:etudiant/features/planning/models/seance_normal_model.dart';

class PlanningRepo {
  final DioHelper dio;
  PlanningRepo(this.dio);

  Future<Either<String, List<SeanceNormaleModel>>> getSeance() async {
    try {
      final response = await dio.getrequest(endpoints: EndPoints.mySchedule);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<SeanceNormaleModel> schedule = data
            .map((e) => SeanceNormaleModel.fromJson(e))
            .toList();

        return Right(schedule);
      }
      return Left("Erreur lors de la récupération du planning.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    } catch (e) {
      return Left("Une erreur inattendue est survenue.");
    }
  }

  Future<Either<String, List<ExamModel>>> getExamen() async {
    try {
      final response = await dio.getrequest(endpoints: EndPoints.myExams);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // FIX: Use ExamenModel.fromJson here
        final List<ExamModel> exams = data
            .map((e) => ExamModel.fromJson(e))
            .toList();

        return Right(exams);
      }
      return Left("Erreur lors de la récupération des examens.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    } catch (e) {
      return Left("Une erreur inattendue est survenue.");
    }
  }

  Future<Either<String, List<ExamModel>>> getExamenRemplacement() async {
    try {
      final response = await dio.getrequest(
        endpoints: EndPoints.myExamsRemplacement,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<ExamModel> exams = data
            .map((e) => ExamModel.fromJson(e))
            .toList();

        return Right(exams);
      }
      return Left("Erreur lors de la récupération des examens.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    } catch (e) {
      return Left("Une erreur inattendue est survenue.");
    }
  }
}
