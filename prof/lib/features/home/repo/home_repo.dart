import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/networking/endpoints.dart';
import 'package:prof/features/home/models/absence_model.dart';
import 'package:prof/features/home/models/profile_model.dart';

class HomeRepo {
  final DioHelper dioHelper;
  HomeRepo(this.dioHelper);

  Future<Either<String, ProfileModel>> getProfile() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getProfile,
      );

      if (response.statusCode == 200) {
        final profile = ProfileModel.fromJson(response.data);
        return Right(profile);
      }
      return Left("Erreur lors de la récupération du profil.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    }
  }

  Future<Either<String, AbsenceModel>> getAbsences() async {
    try {
      final response = await dioHelper.getrequest(endpoints: EndPoints.stats);
      if (response.statusCode == 200) {
        final stats = AbsenceModel.fromJson(response.data);
        return Right(stats);
      }
      return Left("Erreur lors de la récupération des absences.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    }
  }
}
