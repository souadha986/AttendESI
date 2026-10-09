import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/networking/endpoints.dart';
import 'package:prof/features/notifications/model/notification_model.dart';

class NotificationRepo {
  final DioHelper dio;
  NotificationRepo(this.dio);
  Future<Either<String, List<NotificationModel>>> fectchnotifications() async {
    try {
      final response = await dio.getrequest(endpoints: EndPoints.notification);
      if (response.statusCode == 200) {
        final List data = response.data as List;
        final List<NotificationModel> notifications = data
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(notifications);
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
