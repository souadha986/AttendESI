import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/features/absences/models/absence_models.dart';

class AbsenceApi {
  final DioHelper dioHelper;
  AbsenceApi(this.dioHelper);

  // Helper pour extraire le message du body backend
  String _extractMessage(DioException e, String fallback) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ?? fallback;
      }
    } catch (_) {}
    return fallback;
  }


  /// GET FILTRES

  Future<Either<String, FiltreModel>> getFiltres() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.absenceFiltres,
      );

      if (response.statusCode == 200) {
        return Right(FiltreModel.fromJson(response.data));
      }

      return Left("Erreur lors de la récupération des filtres.");
    } on DioException catch (e) {
      return Left(_extractMessage(e, "Erreur réseau. Vérifiez votre connexion."));
    } catch (e) {
      return Left("Erreur inattendue : ${e.toString()}");
    }
  }

 
  /// GET ETUDIANTS (ABSENCE EXAMEN)
 
  Future<Either<String, AbsenceModels>> getEtudiantsAbsence({
    required String situation,
    required String matiereId,
    required String salle,
    required String date,
    String? specialite,
    String? search,
  }) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.absenceEtudiants,
        queryParameters: {
          "situation": situation,
          "matiereId": matiereId,
          "salle": salle,
          "date": date,
          if (specialite != null) "specialite": specialite,
          if (search != null && search.isNotEmpty) "search": search,
        },
      );

      if (response.statusCode == 200) {
        return Right(AbsenceModels.fromJson(response.data));
      }

      return Left("Erreur lors de la récupération des étudiants.");
    } on DioException catch (e) {
      return Left(_extractMessage(e, "Erreur réseau. Vérifiez votre connexion."));
    } catch (e) {
      return Left("Erreur inattendue : ${e.toString()}");
    }
  }

  /// VALIDER ABSENCES
 
  Future<Either<String, ValiderAbsenceResponse>> validerAbsences({
    required ValiderAbsenceModel body,
  }) async {
    try {
      final response = await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.absenceValider,
        data: body.toJson(),
        isTemporary: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(ValiderAbsenceResponse.fromJson(response.data));
      }

      return Left("Erreur lors de la validation des absences.");
    } on DioException catch (e) {
      return Left(_extractMessage(e, "Erreur réseau. Vérifiez votre connexion."));
    } catch (e) {
      return Left("Erreur inattendue : ${e.toString()}");
    }
  }
}