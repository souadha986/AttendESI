import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prof/features/etudiant/cubit/liste_etudiant_state.dart';
import 'package:prof/features/etudiant/module/student_model.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class ListeEtudiantCubit extends Cubit<ListeEtudiantState> {
  final MarquerAbsenceApi api;

  List<StudentModel> cachedStudents = [];

  ListeEtudiantCubit(this.api) : super(ListeEtudiantInitial());

  Future<void> getEtudiantsaveccompteurs({
    required String niveau,
    required String specialite,
    required String groupe,
    required String matiereId,
  }) async {
    emit(ListeEtudiantLoading());
    final result = await api.fetchListeEtudiantsavecCmpteurs(
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      matiereId: matiereId,
    );
    result.fold((left) => emit(ListeEtudiantError(left)), (right) {
      cachedStudents = right;
      emit(ListeEtudiantLoaded(right));
    });
  }

  Future<void> exportToExcel({
    required String niveau,
    required String specialite,
    required String groupe,
    required String matiereId,
  }) async {
    emit(ExportLoading());

    final result = await api.exportExcel(
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      matiereId: matiereId,
    );

    await result.fold((left) async => emit(ExportError(left)), (bytes) async {
      try {
        if (Platform.isAndroid) {
          // For Android 11+ (API 30+)
          final manageStatus = await Permission.manageExternalStorage.request();
          // For Android 10 and below
          final storageStatus = await Permission.storage.request();

          if ((manageStatus.isDenied || manageStatus.isPermanentlyDenied) &&
              (storageStatus.isDenied || storageStatus.isPermanentlyDenied)) {
            emit(ExportError("Permission de stockage refusée"));
            return;
          }
        }

        Directory dir = Platform.isAndroid
            ? Directory("/storage/emulated/0/Download")
            : await getApplicationDocumentsDirectory();

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final String fileName = 'liste_${niveau}_${specialite}_G${groupe}.xlsx';
        final File file = File('${dir.path}/$fileName');

        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);

        emit(ExportSuccess(file.path));
      } catch (e) {
        emit(ExportError("Erreur de sauvegarde: $e"));
      }
    });
  }
}
