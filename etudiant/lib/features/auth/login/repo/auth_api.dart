import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';
import 'package:etudiant/core/utils/secure_storage.dart';
import 'package:etudiant/core/utils/service_locator.dart';
import 'package:etudiant/features/auth/login/models/auth_tokens.dart';

class AuthApi {
  final DioHelper dioHelper;
  AuthApi(this.dioHelper);

  // ✅ On change le retour de String à AuthTokens
  Future<Either<String, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioHelper.postrequest(
        endpoints: EndPoints.login,
        data: {"email": email, "password": password},
      );

      // 1. On crée l'objet complet (qui contient maintenant niveau et spécialité)
      final loginToken = AuthTokens.fromJson(response.data);

      // 2. On stocke les tokens comme avant
      await sl<SecureStorage>().setAccessToken(loginToken.accessToken);
      await sl<SecureStorage>().setRefreshToken(loginToken.refreshToken);

      // ✅ 3. On renvoie l'objet complet au lieu d'un texte
      return Right(loginToken);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
