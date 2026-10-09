import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/tableau_board/model/tableau_bord_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class TableauBordApi {
  final DioHelper dioHelper;

  TableauBordApi(this.dioHelper);

  Future<Either<String, CardsModel>> getTableauBord() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getTableauBord,
      );

      final data = CardsModel.fromJson(response.data as Map<String, dynamic>);

      return Right(data);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<String>>> getNiveaux() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getNiveaux,
      );

      final niveaux = List<String>.from(response.data);

      return Right(niveaux);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<String>>> getSpecialites() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getSpecialites,
      );

      final specialites = List<String>.from(response.data);

      return Right(specialites);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<ChartModel>>> getChart({
    required String niveau,
    String? specialite,
  }) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getChart,
        queryParameters: {
          "niveau": niveau,
          if (specialite != null) "specialite": specialite,
        },
      );

      final List<dynamic> jsonList = response.data as List<dynamic>;

      final charts = jsonList
          .map((json) => ChartModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(charts);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";

      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
