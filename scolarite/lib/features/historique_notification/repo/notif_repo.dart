import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/features/historique_notification/models/notif_models.dart';


class NotifApi {
  final DioHelper dioHelper;

  NotifApi(this.dioHelper);

  Future<Either<String, NotifModel>> getNotifications() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getNotifications, 
      );

    if (response.statusCode == 200) {
  final notif = NotifModel.fromJson(response.data as List<dynamic>);
  return Right(notif);
}

      return Left("Erreur lors de la récupération des notifications.");
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