import 'package:admin/core/assets/images.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ExclusionStatut { enAttente, exclu, derogation }

class ExclusionEntry {
  final String nom, prenom, niveau, specialite, groupe, module, enseignant;

  final int nombreAbsences;
  final ExclusionStatut statut;
  final String authId;
  final String matiereId;
  final bool issick;

  ExclusionEntry({
    required this.nom,
    required this.prenom,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.module,
    required this.enseignant,
    required this.nombreAbsences,
    required this.statut,
    required this.authId,
    required this.matiereId,
    required this.issick,
  });
}

class ExclusionTable extends StatelessWidget {
  final List<ExclusionEntry> entries;
  final void Function(ExclusionEntry entry)? onExaminer;

  const ExclusionTable({super.key, required this.entries, this.onExaminer});

  @override
  Widget build(BuildContext context) {
    const double totalTableWidth = 1400;

    return Container(
      margin: EdgeInsets.all(20.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: totalTableWidth.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Column(
                children: List.generate(
                  entries.length,
                  (index) => _buildRow(entries[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      color: const Color(0xFFE4EEFA),
      child: Row(
        children: [
          _cell("Nom", width: 170.w, isHeader: true),
          _cell("Prénom", width: 110.w, isHeader: true),
          _cell("Niveau", width: 110.w, isHeader: true),
          _cell("Spécialité", width: 120.w, isHeader: true),
          _cell("Groupe", width: 110.w, isHeader: true),
          _cell("Module", width: 170.w, isHeader: true),
          _cell("Enseignant", width: 170.w, isHeader: true),
          _cell("Nombre\nd'Absences", width: 120.w, isHeader: true),
          _cell("Statut", width: 120.w, isHeader: true),
          _cell("Actions", width: 140.w, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildRow(ExclusionEntry e, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          _cellNom(e.nom, width: 170.w, issick: e.issick),
          _cell(e.prenom, width: 110.w),
          _cell(e.niveau, width: 110.w),
          _cell(e.specialite, width: 120.w),
          _cell(e.groupe, width: 110.w),
          _cell(e.module, width: 170.w),
          _cell(e.enseignant, width: 170.w),
          _cell('${e.nombreAbsences}', width: 120.w),
          SizedBox(width: 120.w, child: _statutBadge(e.statut)),
          SizedBox(width: 140.w, child: _actions(e)),
        ],
      ),
    );
  }

  Widget _cell(String text, {required double width, bool isHeader = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: AppStyles.white20w700.copyWith(
          color: isHeader ? const Color(0xFF7B7B7B) : AppColors.blackColor,
          fontSize: isHeader ? 14.sp : 13.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _cellNom(
    String text, {
    required double width,
    bool isHeader = false,
    required bool issick,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          issick
              ? Image.asset(Images.issick, width: 25.w, height: 25.h)
              : const SizedBox(),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              style: AppStyles.white20w700.copyWith(
                color: isHeader
                    ? const Color(0xFF7B7B7B)
                    : AppColors.blackColor,
                fontSize: isHeader ? 14.sp : 13.sp,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statutBadge(ExclusionStatut statut) {
    late String label;
    late Color color;

    switch (statut) {
      case ExclusionStatut.enAttente:
        label = 'En Attente';
        color = const Color(0xFFF5A623);
        break;

      case ExclusionStatut.exclu:
        label = 'Exclu';
        color = const Color(0xFFE15252);
        break;

      case ExclusionStatut.derogation:
        label = 'Dérogation';
        color = const Color(0xFF27AE60);
        break;
    }

    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _actions(ExclusionEntry entry) {
    if (entry.statut != ExclusionStatut.enAttente) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => onExaminer?.call(entry),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0084FF),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Examiner le dossier',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
