import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Prof {
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String? description;
  final String? willayaNaiss;
  final DateTime? dateNaissance;
  final String? modules;

  Prof({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.description,
    this.willayaNaiss,
    this.dateNaissance,
    this.modules,
  });

  List<String> get modulesList =>
      modules
          ?.split(',')
          .map((m) => m.trim())
          .where((m) => m.isNotEmpty)
          .toList() ??
      [];
}

class ArcheiveProfTable extends StatelessWidget {
  final List<Prof> profs;

  final void Function(Prof prof)? ondesarchiver;

  const ArcheiveProfTable({super.key, required this.profs, this.ondesarchiver});

  @override
  Widget build(BuildContext context) {
    const double totalTableWidth = 1500;

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
                  profs.length,
                  (index) => _buildRow(profs[index], index, context),
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
          _cell("Nom", width: 130.w, isHeader: true),
          _cell("Prénom", width: 130.w, isHeader: true),
          _cell("Email", width: 220.w, isHeader: true),
          _cell("Description", width: 200.w, isHeader: true),
          _cell("Wilaya Naissance", width: 150.w, isHeader: true),
          _cell("Date Naissance", width: 150.w, isHeader: true),
          _cell("Modules", width: 250.w, isHeader: true),
          _cell("Actions", width: 220.w, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildRow(Prof p, int index, BuildContext context) {
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
          _cell(p.nom, width: 130.w),
          _cell(p.prenom, width: 130.w),
          _cell(p.email, width: 220.w),
          _cell(p.description ?? '-', width: 200.w),
          _cell(p.willayaNaiss ?? '-', width: 150.w),
          _cell(
            p.dateNaissance != null
                ? DateFormat('dd/MM/yyyy').format(p.dateNaissance!)
                : '-',
            width: 150.w,
          ),
          _modulesCell(p.modulesList, width: 250.w, context: context),
          SizedBox(width: 220.w, child: _actions(p)),
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

  Widget _modulesCell(
    List<String> modules, {
    required double width,
    required BuildContext context,
  }) {
    return SizedBox(
      width: width,
      child: Wrap(
        spacing: 4.w,
        runSpacing: 4.h,
        children: [
          ...modules
              .take(2)
              .map(
                (m) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0969BB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    m,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF0969BB),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          if (modules.length > 2)
            GestureDetector(
              onTap: () => _showModulesDialog(context, modules),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '+${modules.length - 2}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF0969BB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showModulesDialog(BuildContext context, List<String> modules) {
    showDialog(
      context: context,
      builder: (_) => _ModulesDialog(modules: modules),
    );
  }

  Widget _actions(Prof prof) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          "Desarchiver",
          const Color(0xFF1565D8),
          onTap: () => ondesarchiver?.call(prof),
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

class _ModulesDialog extends StatelessWidget {
  final List<String> modules;
  const _ModulesDialog({required this.modules});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modules assignés',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Divider(color: Colors.grey.shade200),
            SizedBox(height: 12.h),

            // ── Modules list ─────────────────────────────────────
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400.h),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: modules
                      .map(
                        (m) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0969BB).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFF0969BB).withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            m,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF0969BB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            SizedBox(height: 16.h),
            // ── Footer ──────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Fermer',
                  style: TextStyle(
                    color: const Color(0xFF0969BB),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
