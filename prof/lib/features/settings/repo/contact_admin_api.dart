import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/networking/endpoints.dart';

class ContactAdminApi {
  final DioHelper dioHelper;
  ContactAdminApi(this.dioHelper);
  Future<Either<String, String>> sendMessage({
    required String sujet,
    required String description,
  }) async {
    try {
      final payload = {"sujet": sujet, "description": description};
      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.contactAdmin,
        data: payload,
        isTemporary: false,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Demande envoyée avec succès.");
      }
      return Left("Serveur temporairement indisponible. Réessayez plus tard.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    }
  }
}
