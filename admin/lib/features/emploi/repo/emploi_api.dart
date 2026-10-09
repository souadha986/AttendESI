import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/emploi/models/emploi_model.dart';

import 'package:admin/features/emploi/models/examen_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class EmploiApi {
  final DioHelper dioHelper;

  EmploiApi(this.dioHelper);

  Future<Either<String, EmploiNormalModel>> getNormalSchedule(
    String niveau,
  ) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.emploiNormal(niveau),
      );
      return Right(
        EmploiNormalModel.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? "Problème de connexion au serveur",
      );
    } catch (_) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, EmploiExamenModel>> getExamens(String niveau) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.emploiExamens(niveau),
      );

      // L'API retourne [] quand il n'y a pas d'examens
      if (response.data is List) {
        return Right(EmploiExamenModel(examens: {}));
      }

      return Right(
        EmploiExamenModel.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? "Problème de connexion au serveur",
      );
    } catch (_) {
      return Left("Une erreur inattendue est survenue");
    }
  }
Future<Either<String, EmploiExamenModel>> getRemplacement(
  String niveau,
) async {
  try {
    final response = await dioHelper.getrequest(
      endpoints: EndPoints.emploiRemplacement(niveau),
    );

    if (response.data is List) {
      return Right(EmploiExamenModel(examens: {}));
    }

    return Right(
      EmploiExamenModel.fromJson(response.data as Map<String, dynamic>),
    );
  } on DioException catch (e) {
    return Left(
      e.response?.data['message'] ?? "Problème de connexion au serveur",
    );
  } catch (_) {
    return Left("Une erreur inattendue est survenue");
  }
}
}
