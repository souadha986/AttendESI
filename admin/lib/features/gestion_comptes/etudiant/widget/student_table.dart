import 'package:admin/core/assets/images.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Student {
  final String nom,
      prenom,
      email,
      niveau,
      specialite,
      groupe,
      matricule,
      dateNaissance,
      lieuNaissance;
  final bool issick;
  Student({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.matricule,
    required this.dateNaissance,
    required this.lieuNaissance,
    required this.issick,
  });
}

class StudentsTable extends StatelessWidget {
  final List<Student> students;
  final void Function(Student student)? onSupprimer;
  final void Function(Student student)? onModifier;
  final void Function(Student student)? onArchiver;

  const StudentsTable({
    super.key,
    required this.students,
    this.onSupprimer,
    this.onModifier,
    this.onArchiver,
  });

  @override
  Widget build(BuildContext context) {
    const double totalTableWidth = 1550;

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
                  students.length,
                  (index) => _buildRow(students[index], index),
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
          _cell("Prénom", width: 120.w, isHeader: true),
          _cell("Email", width: 220.w, isHeader: true),
          _cell("Niveau", width: 100.w, isHeader: true),
          _cell("Spécialité", width: 150.w, isHeader: true),
          _cell("Groupe", width: 100.w, isHeader: true),
          _cell("Matricule", width: 130.w, isHeader: true),
          _cell("Date Naissance", width: 150.w, isHeader: true),
          _cell("Lieu Naissance", width: 150.w, isHeader: true),
          _cell("Actions", width: 220.w, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildRow(Student s, int index) {
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
          _cellnom(s.nom, width: 170.w, issick: s.issick),
          _cell(s.prenom, width: 120.w),
          _cell(s.email, width: 220.w),
          _cell(s.niveau, width: 100.w),
          _cell(s.specialite, width: 150.w),
          _cell(s.groupe, width: 100.w),
          _cell(s.matricule, width: 130.w),
          _cell(s.dateNaissance, width: 150.w),
          _cell(s.lieuNaissance, width: 150.w),
          SizedBox(width: 220.w, child: _actions(s)),
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

  Widget _cellnom(
    String text, {
    required double width,
    bool isHeader = false,
    required bool issick,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // ✅ align icon to top when text wraps
        children: [
          issick
              ? Image.asset(Images.issick, width: 25.w, height: 25.h)
              : const SizedBox(),
          Expanded(
            // ✅ needed so text can wrap inside the Row
            child: Text(
              text,
              softWrap: true, // ✅ allow wrapping
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

  Widget _actions(Student student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          "Supprimer",
          const Color(0xFFE15252),
          onTap: () => onSupprimer?.call(student),
        ),
        SizedBox(width: 20.w),
        _buildActionButton(
          "Modifier",
          const Color(0xFF0084FF),
          onTap: () => onModifier?.call(student),
        ),
        SizedBox(width: 20.w),
        _buildActionButton(
          "Archiver",
          const Color(0xFF1565D8),
          onTap: () => onArchiver?.call(student),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    Color backgroundColor, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
