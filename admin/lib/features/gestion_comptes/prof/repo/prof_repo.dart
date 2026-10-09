import 'dart:developer';

import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/networking/endpoints.dart';

import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProfRepo {
  final DioHelper dioHelper;
  ProfRepo(this.dioHelper);
  Future<Either<String, List<ProfModel>>> getprofs() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.getprofs,
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      final etudiants = jsonList.map((json) {
        final map = Map<String, dynamic>.from(json as Map);
        if (map['modules'] is List) {
          map['modules'] = (map['modules'] as List)
              .map((e) => e.toString())
              .toList();
        }
        return ProfModel.fromJson(map);
      }).toList();
      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e, stack) {
      log('getprofs error: $e\n$stack');
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<ProfModel>>> getarchiveprofs() async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.archeiveprofsliste,
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      final etudiants = jsonList.map((json) {
        final map = Map<String, dynamic>.from(json as Map);
        if (map['modules'] is List) {
          map['modules'] = (map['modules'] as List)
              .map((e) => e.toString())
              .toList();
        }
        return ProfModel.fromJson(map);
      }).toList();
      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e, stack) {
      log('getarchiveprofs error: $e\n$stack');
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<ProfModel>>> searchprofs(String query) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.searchprof,
        queryParameters: {'q': query},
      );
      final etudiants = (response.data as List).map((json) {
        final map = Map<String, dynamic>.from(json as Map);
        if (map['modules'] is List) {
          map['modules'] = (map['modules'] as List)
              .map((e) => e.toString())
              .toList();
        }
        return ProfModel.fromJson(map);
      }).toList();
      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e, stack) {
      log('searchprofs error: $e\n$stack');
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<ProfModel>>> searcharcheiveprofs(
    String query,
  ) async {
    try {
      final response = await dioHelper.getrequest(
        endpoints: EndPoints.searchprofarcheive,
        queryParameters: {'q': query},
      );
      final etudiants = (response.data as List).map((json) {
        final map = Map<String, dynamic>.from(json as Map);
        if (map['modules'] is List) {
          map['modules'] = (map['modules'] as List)
              .map((e) => e.toString())
              .toList();
        }
        return ProfModel.fromJson(map);
      }).toList();
      return Right(etudiants);
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Problème de connexion au serveur";
      return Left(serverMessage);
    } catch (e, stack) {
      log('searcharcheiveprofs error: $e\n$stack');
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> deleteprof(String authId) async {
    try {
      await dioHelper.deleterequest(
        endpoints: EndPoints.supprimeprof,
        data: {"authId": authId},
      );
      return Right("Enseignant supprimé avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de la suppression";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> archiveProf(String authId) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.archeiveeprof,
        data: {"authId": authId},
        isTemporary: false,
      );
      return Right("Enseignant archivé avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'archivage";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> desarchiveProf(String authId) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.desarcheiveeprof,
        data: {"authId": authId},
        isTemporary: false,
      );
      return Right("Enseignant desarchivé avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'archivage";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> updateProf(
    String authId,
    Map<String, dynamic> data,
  ) async {
    try {
      await dioHelper.patchrequest(
        endpoints: "${EndPoints.updateprof}/$authId",
        data: data,
      );
      return const Right("Enseignant modifié avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de la modification";
      return Left(serverMessage);
    } catch (e) {
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> addprof(dynamic data) async {
    try {
      await dioHelper.postrequestwhithtoken(
        endpoints: EndPoints.addprof,
        data: data,
        isTemporary: false,
      );
      return Right("Enseignant Ajouté avec succès");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur lors de l'archivage";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
