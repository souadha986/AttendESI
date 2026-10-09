import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/historique_notification/model/notification_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class NotificationHistoriqueRepo {
  final DioHelper dioHelper;

  NotificationHistoriqueRepo(this.dioHelper);

  /// GET /admin/notification
  Future<Either<String, List<NotificationModel>>> getNotifications() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getAdminNotifications,
      );

      final List<dynamic> jsonList = response.data as List<dynamic>;

      final notifications = jsonList
          .map(
            (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return Right(notifications);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  /// PATCH /admin/notification/mark-read/{id}
  Future<Either<String, NotificationDetailModel>> markAsRead(int id) async {
    try {
      final response = await dioHelper.patchrequest(
        endpoints: "${EndPoints.markNotificationRead}/$id",
        data: {},
      );

      final detail = NotificationDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(detail);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  /// POST /admin/notification/envoyer-notification-personnelle
  Future<Either<String, SendNotificationResponseModel>>
  sendPersonalNotification({
    required String targetAuthId,
    required String titre,
    required String message,
  }) async {
    try {
      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.sendPersonalNotification,
        isTemporary: false,
        data: {
          "targetAuthId": targetAuthId,
          "titre": titre,
          "message": message,
        },
      );

      final result = SendNotificationResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(result);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
