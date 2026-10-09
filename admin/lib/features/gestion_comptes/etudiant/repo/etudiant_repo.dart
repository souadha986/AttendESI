import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';
import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class EtudiantRepo {
  final DioHelper dioHelper;
  EtudiantRepo(this.dioHelper);
  Future<Either<String, List<EtudiantModel>>> getEtudiants() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.listeetudiant,
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      final etudiants = jsonList
          .map((json) => EtudiantModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<EtudiantModel>>> getarchiveEtudiants() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.archiveetudiantliste,
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      final etudiants = jsonList
          .map((json) => EtudiantModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<EtudiantModel>>> searchEtudiants(
    String query,
  ) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.search,
        queryParameters: {'q': query},
      );

      final etudiants = (response.data as List)
          .map((json) => EtudiantModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<EtudiantModel>>> searcharcheiveEtudiants(
    String query,
  ) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.searcharcheive,
        queryParameters: {'q': query},
      );

      final etudiants = (response.data as List)
          .map((json) => EtudiantModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> deleteEtudiant(String authId) async {
    try {
      await dioHelper.deleterequest(
        endpoints: EndPoints.deleteetudiant,
        data: {"authId": authId},
      );
      return Right("Étudiant supprimé avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de la suppression";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> archiveEtudiant(String authId) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.archiveetudiant,
        data: {"authId": authId},
        isTemporary: false,
      );
      return Right("Étudiant archivé avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'archivage";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> desarchiveEtudiant(String authId) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.desarchive,
        data: {"authId": authId},
        isTemporary: false,
      );
      return Right("Étudiant desarchivé avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'archivage";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> updateEtudiant(
    String authId,
    Map<String, dynamic> data,
  ) async {
    try {
      await dioHelper.patchrequest(
        endpoints: "${EndPoints.updateEtudiant}/$authId",
        data: data,
      );
      return const Right("Étudiant modifié avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de la modification";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> addetudiant(dynamic data) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.addetudiant,
        data: data,
        isTemporary: false,
      );
      return Right("Étudiant Ajouté avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'archivage";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
