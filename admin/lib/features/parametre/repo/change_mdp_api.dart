import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/core/utils/secire_storage.dart';
import 'package:admin/core/utils/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ChangePasswordApi {
  final DioHelper dioHelper;

  ChangePasswordApi(this.dioHelper);

  Future<Either<String, String>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Vérification du token
      final token = await sl<SecureStorage>().getaccessToken();

      if (token == null || token.isEmpty) {
        return Left("Vous devez être connecté pour changer le mot de passe");
      }

      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.changeMdp,
        data: {"currentPassword": currentPassword, "newPassword": newPassword},
        isTemporary: false,
      );

      final message =
          response.data['message'] ?? "Mot de passe mis à jour avec succès";

      return Right(message);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
