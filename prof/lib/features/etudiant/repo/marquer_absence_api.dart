import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/networking/endpoints.dart';
import 'package:prof/features/etudiant/module/Envoyer_test_remplacment_request.dart';

import 'package:prof/features/etudiant/module/Envoyer_test_request.dart';
import 'package:prof/features/etudiant/module/etudiant.dart';
import 'package:prof/features/etudiant/module/etudiant_modifier.dart';
import 'package:prof/features/etudiant/module/marquer_absence_request.dart';
import 'package:prof/features/etudiant/module/modifier_absence_request.dart';

import 'package:prof/features/etudiant/module/module.dart';
import 'package:prof/features/etudiant/module/remplcement_model.dart';
import 'package:prof/features/etudiant/module/student_model.dart';

class MarquerAbsenceApi {
  final DioHelper dio;
  MarquerAbsenceApi(this.dio);
  Future<Either<String, List<String>>> fetchnniveaux() async {
    try {
      final response = await dio.getrequest(endpoints: EndPoints.niveau);
      if (response.statusCode == 200) {
        final List data = response.data;
        final List<String> niveaux = data.map((e) => e.toString()).toList();
        return Right(niveaux);
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<String>>> fetchspecialites() async {
    try {
      final response = await dio.getrequest(endpoints: EndPoints.specialite);
      if (response.statusCode == 200) {
        final List data = response.data;
        final List<String> niveaux = data.map((e) => e.toString()).toList();
        return Right(niveaux);
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<String>>> fetchGroupe({
    required String niveau,
    required String specialite,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: "${EndPoints.groupe}/$niveau",
        queryParameters: {"specialite": specialite},
      );

      if (response.statusCode == 200) {
        final List groupesList = response.data;
        final List<String> groupes = groupesList
            .map((e) => e.toString())
            .toList();
        return Right(groupes);
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<Module>>> fetchModuleTest({
    required String niveau,
    required String specialite,
    required List<String> groupe,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: "${EndPoints.moduletest}/$niveau/$specialite",
        queryParameters: {
          "specialite": specialite,
          "niveau": niveau,
          "groupes": groupe,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        final List<Module> modules = data
            .map((e) => Module.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(modules);
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<Module>>> fetchModule({
    required String niveau,
    required String specialite,
    required String groupe,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: "${EndPoints.module}/$groupe",
        queryParameters: {
          "specialite": specialite,
          "niveau": niveau,
          "groupe": groupe,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        final List<Module> modules = data
            .map((e) => Module.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(modules);
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<Etudiant>>> fetchEtudiants({
    required String niveau,
    required String specialite,
    required String groupe,
    required int matiereId,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: "${EndPoints.marqueretudiant}/$groupe",
        queryParameters: {
          "matiereId": matiereId,
          "specialite": specialite,
          "niveau": niveau,
          "groupe": groupe,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        final List<Etudiant> etudiants = data
            .map((e) => Etudiant.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(etudiants);
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> marquerAbsences(
    MarquerAbsenceRequest request,
  ) async {
    try {
      final response = await dio.postrequestwhithtoken(
        isTemporary: false,
        endpoints: EndPoints.marquerabsence,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("marqué avec succès");
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> modifierAbsences(
    ModifierAbsenceRequest request,
  ) async {
    try {
      final response = await dio.putrequest(
        endpoints: EndPoints.edit,
        data: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("modifié avec succès");
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<EtudiantModifier>>> fetchEtudiantsmodifies({
    required String niveau,
    required String specialite,
    required String groupe,
    required String matiereid,
    required String date,
    required String heure,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: EndPoints.editetudiant,
        queryParameters: {
          "specialite": specialite,
          "niveau": niveau,
          "groupe": groupe,
          "matiereId": matiereid,
          "date": date,
          "heureDebut": heure,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        final List<EtudiantModifier> etudiants = data
            .map((e) => EtudiantModifier.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(etudiants);
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<StudentModel>>> fetchListeEtudiantsavecCmpteurs({
    required String niveau,
    required String specialite,
    required String groupe,
    required String matiereId,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: "${EndPoints.fetchlistecompteur}/$groupe/$matiereId",
        queryParameters: {
          "niveau": niveau,
          "specialite": specialite,
          "groupe": groupe,
          "matiereId": matiereId,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        // We map manually to catch which specific item might be failing
        final List<StudentModel> students = data.map((e) {
          try {
            return StudentModel.fromJson(e as Map<String, dynamic>);
          } catch (e) {
            debugPrint("Mapping Error for student: $e");
            throw Exception("Format de données invalide");
          }
        }).toList();

        return Right(students);
      }

      return const Left("Une erreur serveur est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Erreur de connexion au serveur";
      return Left(serverMessage);
    } catch (e) {
      debugPrint("General Error: $e");
      return const Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<int>>> exportExcel({
    required String niveau,
    required String specialite,
    required String groupe,
    required String matiereId,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints:
            "${EndPoints.exporterexel}/$niveau/$specialite/$groupe/$matiereId",
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        final List<int> bytes = (raw as List).cast<int>();
        return Right(bytes);
      }
      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, String>> envoyerTest(EnvoyerTestRequest request) async {
    try {
      final json = request.toJson();
      log(json.toString());
      final response = await dio.postrequestwhithtoken(
        endpoints: EndPoints.test,
        data: request.toJson(),
        isTemporary: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("Notification envoyer avec succes");
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }

  Future<Either<String, List<RemplacementModel>>> fetchEligibleAbsents({
    required String matiereId,
    required String dateAbsence,
    required String niveau,
    required String specialite,
    required List<int> groupIds,
  }) async {
    try {
      final response = await dio.getrequest(
        endpoints: EndPoints.listetest,
        queryParameters: {
          "matiereId": matiereId,
          "dateAbsence": dateAbsence,
          "niveau": niveau,
          "specialite": specialite,
          "groupIds": groupIds,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;

        final List<RemplacementModel> students = data.map((e) {
          try {
            return RemplacementModel.fromJson(e as Map<String, dynamic>);
          } catch (err) {
            debugPrint("Mapping Error for student: $err");
            throw Exception("Format de données invalide");
          }
        }).toList();

        return Right(students);
      } else {
        return Left("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
      return Left(
        "Une erreur est survenue lors de la récupération des données.",
      );
    }
  }

  Future<Either<String, String>> envoyeRTestRemplacement(
    EnvoyerTestRemplacementRequest request,
  ) async {
    try {
      final json = request.toJson();
      log(json.toString());
      final response = await dio.postrequestwhithtoken(
        endpoints: EndPoints.remplacement,
        data: request.toJson(),
        isTemporary: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("Notification envoyer avec succes");
      }

      return Left("Une erreur inattendue est survenue");
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data['message'] ?? "Une erreur inattendue est survenue";
      return Left(serverMessage);
    } catch (e) {
      return Left("Une erreur inattendue est survenue");
    }
  }
}
