import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';

class NotificationServiceRepo {
  final DioHelper dioHelper;
  NotificationServiceRepo(this.dioHelper);

  Future<Either<String, bool>> uploadFcmToken(String token) async {
    try {
      await dioHelper.postrequestwhithtoken(
        isTemporary: false,
        endpoints: '/authStudent/fcm-token',
        data: {"fcmToken": token},
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Erreur synchronisation");
    } catch (e) {
      return const Left("Erreur inattendue");
    }
  }
}
