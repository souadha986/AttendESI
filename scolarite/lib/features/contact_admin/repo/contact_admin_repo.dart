import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';

class ContactAdminRepo {
  final DioHelper dio;

  ContactAdminRepo(this.dio);

  Future<Either<String, String>> sendMessage({
    required String sujet,
    required String description,
  }) async {
    try {
      final formData = FormData.fromMap({
        'sujet': sujet,
        'description': description,
      });

      final response = await dio.postrequestwhithtoken(
        endpoints: EndPoints.contactAdmin,
        data: formData,
        isTemporary: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['message'] ?? "Message envoyé avec succès");
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ??
            "Problème de connexion serveur",
      );
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
