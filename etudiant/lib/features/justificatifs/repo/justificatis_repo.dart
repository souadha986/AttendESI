import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/networking/endpoints.dart';

import 'package:etudiant/features/justificatifs/models/justification.dart';

class JustificatifsRepo {
  final DioHelper dio;
  JustificatifsRepo(this.dio);
  Future<Either<String, List<Justification>>> getjustifications() async {
    try {
      final response = await dio.getrequest(
        endpoints: EndPoints.getjustificatif,
      );
      if (response.statusCode == 200) {
        final List<Justification> justification = Justification.fromList(
          response.data,
        );
        return Right(justification);
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Map<int, String>> getMatieres() async {
    try {
      final response = await dio.getrequest(endpoints: EndPoints.getmatiers);
      if (response.statusCode == 200) {
        final List data = response.data;
        return {for (var m in data) m['id'] as int: m['nom_matiere'] as String};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Either<String, String>> deletejustification(String id) async {
    try {
      final response = await dio.deleterequest(
        endpoints: EndPoints.deleteandupdatejustificatif(id),
      );
      if (response.statusCode == 200) {
        return Right('Justificatif supprimé avec succès.');
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "probleme de connexion de serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> uploadJustificatif({
    required List<int> matiereIds,
    required String dateAbsenceDebut,
    required String dateAbsenceFin,
    required String typeJustification,
    required String raison,
    required String filePath,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'matiereIds': matiereIds, // Changed key name
        'dateAbsenceDebut': dateAbsenceDebut, // Changed key name
        'dateAbsenceFin': dateAbsenceFin, // Changed key name
        'typeJustification': typeJustification,
        'raison': raison,
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await dio.postrequestwhithtoken(
        endpoints: EndPoints.uploadjustificatifs,
        data: data,
        isTemporary: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Justificatif soumis avec succès");
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      print("Upload error: ${e.response?.data}");
      return Left(e.response?.data['message'] ?? "Problème de connexion");
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> updatejustification(
    String id, {
    required List<int> matiere,
    required String datedebutAbsence,
    required String datefinAbsence,
    required String typeJustification,
    required String raison,
    required String filePath,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'matiereIds': matiere,
        'dateAbsenceDebut': datedebutAbsence,
        'dateAbsenceFin': datefinAbsence,
        'typeJustification': typeJustification,
        'raison': raison,
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await dio.patchrequest(
        endpoints: EndPoints.deleteandupdatejustificatif(id),
        data: data,
      );
      if (response.statusCode == 200) {
        return Right('Justificatif modifié avec succès.');
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "probleme de connexion de serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
