import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/features/dashboard/models/dashboard_models.dart';

class DashboardRepo {
  final DioHelper dioHelper;

  DashboardRepo(this.dioHelper);

  /// Handler commun pour les erreurs
  String _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 401:
        return "Session expirée. Veuillez vous reconnecter.";
      case 500:
        return "Erreur serveur. Réessayez plus tard.";
      default:
        return "Erreur réseau. Vérifiez votre connexion.";
    }
  }

  /// Handler commun pour les réponses
  Either<String, T> _handleResponse<T>(
    Response response,
    T Function(dynamic json) fromJson,
    String errorMessage,
  ) {
    if (response.statusCode == 200) {
      return Right(fromJson(response.data));
    } else {
      return Left(errorMessage);
    }
  }

  /// Dashboard
  Future<Either<String, CardsModel>> getDashboard() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.dashboard,
      );

      return _handleResponse(
        response,
        (json) => CardsModel.fromJson(json),
        "Erreur lors de la récupération du dashboard.",
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  /// Graphique Absences
  Future<Either<String, BarModel>> getGraphiqueAbsences({
    required String niveau,
  }) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.graphiqueAbsences,
        queryParameters: {'niveau': niveau},
      );

      return _handleResponse(
        response,
        (json) => BarModel.fromJson(json),
        "Erreur lors de la récupération du graphique d'absences.",
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  /// Graphique Justification
  Future<Either<String, PieModel>> getGraphiqueJustification({
    required String typeSeance,
  }) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.graphiqueJustification,
        queryParameters: {
          'typeSeance': typeSeance.trim(),
        },
      );

      return _handleResponse(
        response,
        (json) => PieModel.fromJson(json),
        "Erreur lors de la récupération du graphique de justification.",
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }
}