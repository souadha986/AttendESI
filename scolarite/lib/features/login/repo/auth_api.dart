//so to resume everything in dio methodes post,or get we throw the errors to the function that use it and after that we handle dio exeption the error, coming from servers ....
//we do this when we have either and we want to show  the errors

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/core/utils/secure_storage.dart';
import 'package:scolarite/core/utils/service_locator.dart';
import 'package:scolarite/features/login/models/auth_tokens.dart';

class AuthApi {
  final DioHelper dioHelper;
  AuthApi(this.dioHelper);
  Future<Either<String, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioHelper.postrequest(
        endpoints: EndPoints.login,
        data: {"email": email, "password": password},
      );

      final loginToken = AuthTokens.fromJson(response.data);
      await sl<SecureStorage>().setAccessToken(loginToken.accessToken);
      await sl<SecureStorage>().setRefreshToken(loginToken.refreshToken);
      return Right("Connexion réussie !");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "probleme de connexion de serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
