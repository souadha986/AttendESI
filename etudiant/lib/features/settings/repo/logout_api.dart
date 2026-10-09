import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';
import 'package:etudiant/core/utils/service_locator.dart';
import 'package:etudiant/core/utils/secure_storage.dart';

class LogoutApi {
  final DioHelper dioHelper;
  LogoutApi(this.dioHelper);

  Future<Either<String, String>> logout() async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.logout,
        data: {},
        isTemporary: false,
      );
      await _clearTokens();
      return Right('Déconnexion réussie');
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "probleme de connexion de serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<void> _clearTokens() async {
    await sl<SecureStorage>().removeaccessToken();
    await sl<SecureStorage>().getrefreshToken();
  }
}
