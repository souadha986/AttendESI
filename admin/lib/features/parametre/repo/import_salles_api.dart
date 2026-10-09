import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/parametre/model/import_salles_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ImportSallesApi {
  final DioHelper dioHelper;

  ImportSallesApi(this.dioHelper);

  Future<Either<String, ImportSallesModel>> importSalles({
    required String fileName,
    required List<int> fileBytes,  // bytes au lieu de path
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.importSalles,
        data: formData,
        isTemporary: false,
      );

      final model = ImportSallesModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(model);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}