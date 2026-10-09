import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/gestion_comptes/etudiant/models/import_etudiant_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ImportEtudiantApi {
  final DioHelper dioHelper;

  ImportEtudiantApi(this.dioHelper);

  Future<Either<String, ImportEtudiantModel>> importEtudiants({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.importEtudiants,
        data: formData,
        isTemporary: false,
      );

      return Right(ImportEtudiantModel.fromJson(
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