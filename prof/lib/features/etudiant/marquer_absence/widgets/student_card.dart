import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';

class StudentCard extends StatefulWidget {
  final String fullname;
  final String matricule;
  final String? status;
  final Function(String) onSelect;

  const StudentCard({
    super.key,
    required this.fullname,
    required this.matricule,
    required this.status,
    required this.onSelect,
  });

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE4EEFA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fullname,
                  style: AppStyles.black13w500.copyWith(fontSize: 16.sp),
                ),
                Text(widget.matricule, style: TextStyle(fontSize: 12.sp)),
              ],
            ),
          ),

          _buildButton("P", widget.status == "P", () => widget.onSelect("P")),
          WidthSpace(5),
          _buildButton("A", widget.status == "A", () => widget.onSelect("A")),
        ],
      ),
    );
  }
}

Widget _buildButton(String text, bool active, VoidCallback onTap) {
  Color baseColor = text == "P" ? Colors.green : Colors.red;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: active ? baseColor.withOpacity(0.8) : baseColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
