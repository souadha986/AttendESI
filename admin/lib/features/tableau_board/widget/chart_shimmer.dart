import 'package:admin/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ChartShimmer extends StatelessWidget {
  const ChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerEffect(
          baseColor: const Color(0xFFDCE8F7),
          highlightColor: const Color(0xFFBFD4F2),
          child: Container(
            height: 550.h,
            width: 980.w,
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xff386BBC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeightSpace(10),
                Container(
                  width: 300.w,
                  height: 30.h,
                  color: const Color(0xFFDCE8F7),
                ),
                HeightSpace(30),

                /// CHART
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: const Color(0xff386BBC),
                          width: 2.w,
                        ),
                        bottom: BorderSide(
                          color: const Color(0xff386BBC),
                          width: 2.w,
                        ),
                      ),
                    ),
                    height: 350.h,
                    width: 600.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (index) {
                        final height = (index + 1) * 40.0;
                        return Container(
                          width: 30.w,
                          height: height.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6095E8),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                HeightSpace(30),

                /// LEGEND
                Row(
                  children: [
                    WidthSpace(50),
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF6095E8),
                      ),
                    ),
                    WidthSpace(10),
                    Container(
                      width: 150.w,
                      height: 20.h,
                      color: const Color(0xFFDCE8F7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
