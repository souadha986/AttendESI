import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JustificationCard extends StatefulWidget {
  final List<String> matieres;
  final String date;
  final String type;
  final String status;
  final void Function() onPressmodifier;
  final void Function() onPresssupprimer;
  final String? submissionDate;
  final String? commentaire;
  final bool showAdminComment;
  const JustificationCard({
    super.key,
    required this.matieres,
    required this.date,
    required this.type,
    required this.status,
    required this.onPressmodifier,
    required this.onPresssupprimer,
    this.submissionDate,
    this.commentaire,
    this.showAdminComment = true,
  });

  @override
  State<JustificationCard> createState() => _JustificationCardState();
}

class _JustificationCardState extends State<JustificationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String statusNormalized = widget.status;

    Color statusBg;
    String adminCommentText;

    if (statusNormalized == "Valide" || statusNormalized == "Validé") {
      statusBg = const Color(0xFFB1DDC5);
      adminCommentText = widget.commentaire?.isNotEmpty == true
          ? widget.commentaire!
          : "Justificatif accepté";
    } else if (statusNormalized == "Refuse" ||
        statusNormalized == "Refusé" ||
        statusNormalized == "Réfuser" ||
        statusNormalized == "Refuser") {
      statusBg = const Color(0xFFF0B9B3);
      adminCommentText = widget.commentaire?.isNotEmpty == true
          ? widget.commentaire!
          : "Justificatif refusé";
    } else {
      statusBg = const Color(0xFFF0E2B3);
      adminCommentText = "";
    }

    final bool isPending = statusNormalized == "En Attente";

    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.matieres.length > 1) {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.matieres.isNotEmpty
                              ? widget.matieres.first
                              : "Aucune matière",
                          style: AppStyles.grey20w500.copyWith(
                            color: const Color(0xFF454545),
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      if (widget.matieres.length > 1)
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.blueColorA,
                          size: 24.sp,
                        ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.status,
                  style: AppStyles.black15w600.copyWith(
                    color: const Color(0xFF454545),
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),

          if (_isExpanded && widget.matieres.length > 1) ...[
            const HeightSpace(8),
            Container(
              padding: EdgeInsets.only(left: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.matieres.skip(1).map((matiere) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      matiere,
                      style: AppStyles.grey14w600.copyWith(
                        color: const Color(0xFF666666),
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const HeightSpace(12),

          Text("Date:${widget.date}", style: TextStyle(fontSize: 14.sp)),

          const HeightSpace(8),
          Text(
            widget.type,
            style: AppStyles.black15w600.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: const Color(0xFF123A7A),
            ),
          ),

          if (widget.showAdminComment && !isPending) ...[
            const HeightSpace(12),
            Text(
              "Commentaire Administrateur:",
              style: AppStyles.blueA15w500.copyWith(
                fontSize: 14.sp,
                color: const Color(0xFF123A7A),
              ),
            ),
            const HeightSpace(4),
            Text(
              adminCommentText,
              style: const TextStyle(
                color: Color(0xFF00A3FF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          // Submission date
          if (widget.submissionDate != null &&
              widget.submissionDate!.isNotEmpty) ...[
            const HeightSpace(12),
            Text(
              "Soumis le :${widget.submissionDate}",
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
          if (isPending) ...[
            const HeightSpace(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100.w,
                  height: 40.h,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1351FE), Color(0xFF04AAEF)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: widget.onPressmodifier,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Modifier",
                        style: AppStyles.black15w600.copyWith(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                const WidthSpace(10),
                SizedBox(
                  width: 100.w,
                  height: 40.h,
                  child: OutlinedButton(
                    onPressed: widget.onPresssupprimer,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF00A3FF),
                        width: 1.5,
                      ),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Supprimer",
                      style: AppStyles.black15w600.copyWith(
                        color: const Color(0xFF00A3FF),
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
