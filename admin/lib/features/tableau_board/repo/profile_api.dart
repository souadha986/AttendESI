import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/tableau_board/model/profil_model.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProfilApi {
  final DioHelper dioHelper;

  ProfilApi(this.dioHelper);

  Future<Either<String, ProfilModel>> getProfile() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getProfile,
      );

      final profile = ProfilModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(profile);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
