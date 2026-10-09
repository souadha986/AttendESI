import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';
import 'package:etudiant/features/qr_code/model/qr_model.dart';

class QrcodeRepo {
  final DioHelper dio;
  QrcodeRepo(this.dio);

  Future<Either<String, String>> scanQr(ScanRequestModel model) async {
    try {
      final response = await dio.postrequestwhithtoken(
        isTemporary: false,
        endpoints: EndPoints.scane,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Présence enregistrée avec succès !");
      }
      return Left("Erreur lors de l'enregistrement de la présence.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left("Session expirée. Veuillez vous reconnecter.");
      }
      if (e.response?.statusCode == 400) {
        return Left(e.response?.data?['message'] ?? "Données invalides.");
      }
      if (e.response?.statusCode == 500) {
        return Left("Erreur serveur. Réessayez plus tard.");
      }
      return Left("Erreur réseau. Vérifiez votre connexion.");
    } catch (e) {
      return Left("Une erreur inattendue est survenue.");
    }
  }
}
