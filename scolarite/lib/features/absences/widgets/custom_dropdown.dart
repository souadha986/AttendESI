import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? hint;
  final bool enabled;
  const CustomDropdown({
    super.key,
    required this.title,
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: AppStyles.black45Bold12.copyWith(fontSize: 16.sp),
          ),
        ),
        HeightSpace(10),
        Container(
          width: 300.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Color(0xffF0F7FE),
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(22.r),
              dropdownColor: Color(0xffF0F7FE),
              value: value,
              hint: Text(hint ?? "Sélectionner"),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              style: AppStyles.black45Bold12.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w100,
              ),
              onChanged: enabled ? onChanged : null,
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Center(child: Text(item)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
