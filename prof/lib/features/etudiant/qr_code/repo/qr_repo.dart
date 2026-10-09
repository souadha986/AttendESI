import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/networking/endpoints.dart';
import 'package:prof/features/etudiant/qr_code/model/qr_model.dart';

class GenerateQrRepo {
  final DioHelper dio;
  GenerateQrRepo(this.dio);

  Future<Either<String, String>> generateQr(GenerateQrModel model) async {
    try {
      final response = await dio.postrequestwhithtoken(
        isTemporary: false,
        endpoints: EndPoints.generateQr,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // response.data is the QR string/token
        final String qrData =
            response.data['qrToken'] ??
            response.data['token'] ??
            response.data.toString();
        return Right(qrData);
      }
      return Left("Erreur lors de la génération du QR code.");
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
