import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/Bottons.dart';
import 'package:prof/core/widgets/spacing.dart';

class Etudiant extends StatefulWidget {
  const Etudiant({super.key});

  @override
  State<Etudiant> createState() => _EtudiantState();
}

class _EtudiantState extends State<Etudiant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consernant Etudiant", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeightSpace(65),
              Text(
                "Gestions des Absences:",
                style: AppStyles.black25w700.copyWith(
                  color: AppColors.blueColorA,
                ),
              ),
              HeightSpace(26),
              Bottons(
                onPress: () {
                  context.pushNamed(AppRoutes.marquerabsence1);
                },
                title: "Marquer les absences",
                textstyle: AppStyles.white15w700,
              ),
              HeightSpace(26),
              Bottons(
                onPress: () {
                  context.pushNamed(AppRoutes.modifierabsence1);
                },
                title: "Modifier les absences",
                textstyle: AppStyles.white15w700,
              ),
              HeightSpace(26),
              Bottons(
                onPress: () {
                  context.pushNamed(AppRoutes.consulterliste1);
                },
                title: "Consulter la liste des etudiants",
                textstyle: AppStyles.white15w700,
              ),
              HeightSpace(60),
              Text(
                "Gestions des Tests:",
                style: AppStyles.black25w700.copyWith(
                  color: AppColors.blueColorA,
                ),
              ),
              HeightSpace(26),
              Bottons(
                onPress: () {
                  context.pushNamed(AppRoutes.envoyertest1);
                },
                title: "Envoyer message test",
                textstyle: AppStyles.white15w700,
              ),
              HeightSpace(26),
              Bottons(
                onPress: () {
                  context.pushNamed(AppRoutes.remplacement1);
                },
                title: "Remplacement d’un test",
                textstyle: AppStyles.white15w700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
