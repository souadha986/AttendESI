import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/networking/endpoints.dart';
import 'package:prof/core/utils/secire_storage.dart';
import 'package:prof/core/utils/service_locator.dart';

class OtpApi {
  final DioHelper dioHelper;

  OtpApi(this.dioHelper);

  Future<Either<String, String>> sendOtp({required String email}) async {
    try {
      await dioHelper.postrequest(
        endpoints: EndPoints.sendOtp,
        data: {"email": email},
      );
      return const Right("Code envoyé avec succès !");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> resendOtp({required String email}) async {
    try {
      await dioHelper.postrequest(
        endpoints: EndPoints.sendOtp,
        data: {"email": email},
      );
      return const Right("Code renvoyé avec succès !");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await dioHelper.postrequest(
        endpoints: EndPoints.verifyOtp,
        data: {"email": email, "otp": otp},
      );

      // Saving token upon successful verification
      await sl<SecureStorage>().setauthtoken(response.data['access_token']);
      return const Right("Code vérifié avec succès !");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Code incorrect ou expiré";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> changepassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final String? token = await sl<SecureStorage>().getauthtoken();

      log("Sending Token: $token");
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.changepassword,
        data: {"email": email, "otp": otp, "newPassword": newPassword},

        isTemporary: true,
      );

      await sl<SecureStorage>().removeauthtoken();
      return const Right("Mot de passe modifié avec succès !");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ??
          "Échec de la modification du mot de passe";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }
}
