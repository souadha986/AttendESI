import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';
import 'package:etudiant/core/utils/secure_storage.dart';
import 'package:etudiant/core/utils/service_locator.dart';

class ChangePasswordApi {
  final DioHelper dioHelper;
  ChangePasswordApi(this.dioHelper);

  Future<Either<String, String>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Check if token exists first
      final token = await sl<SecureStorage>().getaccessToken();
      if (token == null || token.isEmpty) {
        return Left("Vous devez être connecté pour changer le mot de passe");
      }

      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.updatePassword,
        data: {"currentPassword": currentPassword, "newPassword": newPassword},
        isTemporary: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
          response.data['message'] ?? "Mot de passe mis à jour avec succès",
        );
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter");
      }
      final serverMessage =
          e.response?.data['message'] ?? "probleme de connexion de serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
