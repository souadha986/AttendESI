import 'dart:developer';

import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/gestion_comptes/scolarite/models/scolarite_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ScolariteRepo {
  final DioHelper dioHelper;
  ScolariteRepo(this.dioHelper);

  Future<Either<String, List<ScolariteModel>>> getScolarites() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getscolarite,
      );
      final List<dynamic> jsonList = response.data['data'] as List<dynamic>;
      final list = jsonList
          .map((json) => ScolariteModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e, stack) {
      log('getScolarites error: $e\n$stack');
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> addScolarite(dynamic data) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.addscolarite,
        data: data,
        isTemporary: false,
      );
      return Right("Scolarité ajoutée avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'ajout";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> updateScolarite(
    String authId,
    Map<String, dynamic> data,
  ) async {
    try {
      await dioHelper.patchrequest(
        endpoints: "${EndPoints.modifierscolarite(authId)}",
        data: data,
      );
      return const Right("Scolarité modifiée avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de la modification";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> deleteScolarite(String authId) async {
    try {
      await dioHelper.deleterequest(
        endpoints: EndPoints.scolaritedelete(authId),
        data: {"authId": authId},
      );
      return Right("Scolarité supprimée avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de la suppression";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
