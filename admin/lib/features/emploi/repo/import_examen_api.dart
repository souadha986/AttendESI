import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/emploi/models/import_examen_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ImportExamenApi {
  final DioHelper dioHelper;

  ImportExamenApi(this.dioHelper);

  Future<Either<String, ImportExamenModel>> importExamenEmd({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.importExamensEmd,
        data: formData,
        isTemporary: false,
      );

      return Right(ImportExamenModel.fromJson(
        response.data as Map<String, dynamic>,
      ));
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, ImportExamenModel>> importExamenRemplacement({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.importExamensRemplacement,
        data: formData,
        isTemporary: false,
      );

      return Right(ImportExamenModel.fromJson(
        response.data as Map<String, dynamic>,
      ));
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}