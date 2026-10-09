import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';

class JustificatifsApi {
  final DioHelper dioHelper;

  JustificatifsApi(this.dioHelper);

  /// GET ALL
  Future<Either<String, List<JustificatifsModel>>> getAllJustificatifs() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getAllJustificatifs,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        final justificatifs = data
            .map((e) => JustificatifsModel.fromJson(e))
            .toList();

        // Tri
        String normalizeStatus(String? status) {
          return (status ?? "")
              .toLowerCase()
              .replaceAll("é", "e")
              .replaceAll("è", "e")
              .trim();
        }

        int getStatusPriority(String? status) {
          final s = normalizeStatus(status);

          if (s == "en attente") return 0;
          if (s == "refuse") return 1;
          if (s == "valide") return 2;

          return 3;
        }

        justificatifs.sort((a, b) {
          final priorityA = getStatusPriority(a.status);
          final priorityB = getStatusPriority(b.status);

          if (priorityA != priorityB) {
            return priorityA.compareTo(priorityB);
          }

          // même status → tri par date (plus récent en premier ou ancien)
          return (b.dateSoumission ?? DateTime(0)).compareTo(
            a.dateSoumission ?? DateTime(0),
          );
        });

        return Right(justificatifs);
      }

      return Left("Erreur lors de la récupération.");
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// SEARCH
  Future<Either<String, List<JustificatifsModel>>> searchJustificatifs(
    String query,
  ) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: "${EndPoints.searchJustificatifs}?search=$query",
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        final justificatifs = data
            .map((e) => JustificatifsModel.fromJson(e))
            .toList();

        return Right(justificatifs);
      }

      return Left("Erreur lors de la recherche.");
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Gestion centralisée des erreurs
  Either<String, List<JustificatifsModel>> _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Left("Session expirée. Reconnectez-vous.");
    } else if (e.response?.statusCode == 500) {
      return Left("Erreur serveur.");
    } else {
      return Left("Erreur réseau.");
    }
  }

  Future<Either<String, JustificatifDetails>> getJustificatifDetails(
    int id,
  ) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getJustificatifDetails(id),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final justificatif = JustificatifDetails.fromJson(data);

        return Right(justificatif);
      }

      return Left("Erreur lors de la récupération des détails.");
    } on DioException catch (e) {
      return _handleDetailsError(e);
    }
  }

  Either<String, JustificatifDetails> _handleDetailsError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Left("Session expirée. Reconnectez-vous.");
    } else if (e.response?.statusCode == 404) {
      return Left("Justificatif introuvable.");
    } else if (e.response?.statusCode == 500) {
      return Left("Erreur serveur.");
    } else {
      return Left("Erreur réseau.");
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////
  Future<Either<String, JustificatifTraitement>> validerJustificatif(
    int id,
  ) async {
    try {
      final response = await dioHelper.patchrequest(
        endpoints: EndPoints.validerJustificatif(id),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final result = JustificatifTraitement.fromJson(data);

        return Right(result);
      }

      return Left("Erreur lors de la validation.");
    } on DioException catch (e) {
      return _handleTraitementError(e);
    }
  }

  Either<String, JustificatifTraitement> _handleTraitementError(
    DioException e,
  ) {
    if (e.response?.statusCode == 401) {
      return Left("Session expirée. Reconnectez-vous.");
    } else if (e.response?.statusCode == 404) {
      return Left("Justificatif introuvable.");
    } else if (e.response?.statusCode == 500) {
      return Left("Erreur serveur.");
    } else {
      return Left("Erreur réseau.");
    }
  }

  Future<Either<String, JustificatifTraitement>> refuserJustificatif(
    int id,
    String commentaire,
  ) async {
    try {
      final response = await dioHelper.patchrequest(
        endpoints: EndPoints.refusererJustificatif(id),
        data: {"commentaire": commentaire},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final result = JustificatifTraitement.fromJson(data);

        return Right(result);
      }

      return Left("Erreur lors du refus du justificatif.");
    } on DioException catch (e) {
      return _handleTraitementError(e);
    }
  }
}
