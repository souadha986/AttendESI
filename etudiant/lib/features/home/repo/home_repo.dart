import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';
import 'package:etudiant/features/home/models/absence_model.dart';
import 'package:etudiant/features/home/models/alerte_model.dart';
import 'package:etudiant/features/home/models/profile_model.dart';

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

  Future<Either<String, List<AbsenceModuleModel>>> getAbsences() async {
    try {
      final response = await dioHelper.getrequest(endpoints: EndPoints.absence);

      if (response.statusCode == 200) {
        final List data = response.data['taux_absence_par_module'];
        final modules = data
            .map((e) => AbsenceModuleModel.fromJson(e))
            .toList();
        return Right(modules);
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

  Future<Either<String, List<AlertModel>>> getAlerts() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: '/absence/student-alerts',
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        final alerts = data.map((e) => AlertModel.fromJson(e)).toList();
        return Right(alerts);
      }
      return Left("Erreur lors de la récupération des alertes.");
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

  Future<Either<String, bool>> markAlertAsRead(int alertId) async {
    try {
      final response = await dioHelper.postrequestwhithtoken(
        isTemporary: false,
        endpoints: '/absence/student-alerts/read/$alertId',
        data: {'alertId': alertId},
      );

      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left("Erreur lors de la mise à jour de l'alerte.");
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
