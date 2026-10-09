import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/core/widgets/Bottons.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/justificatifs/cubit/justificatifs_cubit.dart';
import 'package:etudiant/features/justificatifs/cubit/justificatifs_state.dart';
import 'package:etudiant/features/justificatifs/models/justification.dart';
import 'package:etudiant/features/justificatifs/widgets/aucune_justification.dart';
import 'package:etudiant/features/justificatifs/widgets/justification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class Justificatifs extends StatefulWidget {
  const Justificatifs({super.key});

  @override
  State<Justificatifs> createState() => _JustificatifsState();
}

class _JustificatifsState extends State<Justificatifs> {
  @override
  void initState() {
    super.initState();
    context.read<JustificatifsCubit>().fetchjustificatifs();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _navigateToSubmit() {
    context.pushNamed(AppRoutes.soumettrejustificatif).then((_) {
      if (context.mounted) {
        context.read<JustificatifsCubit>().fetchjustificatifs();
      }
    });
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<JustificatifsCubit>(),
          child: BlocConsumer<JustificatifsCubit, JustificationState>(
            listener: (context, state) {
              if (state is LoadedState) {
                Navigator.of(dialogContext).pop();
              }
              if (state is DeleteErrorState) {
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.error,
                  type: AnimatedSnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is DeleteLoadingState;
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                backgroundColor: AppColors.greyColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0B9B3).withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 38.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      HeightSpace(20),
                      Text(
                        'Supprimer le justificatif',
                        style: AppStyles.blueA20w700.copyWith(fontSize: 17.sp),
                        textAlign: TextAlign.center,
                      ),
                      HeightSpace(10),
                      Text(
                        'Cette action est irréversible.\nVoulez-vous vraiment continuer ?',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      HeightSpace(28),
                      isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: CircularProgressIndicator(
                                color: AppColors.blueColorA,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(dialogContext).pop(),
                                    child: Container(
                                      height: 46.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.blueColorA,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Annuler',
                                          style: AppStyles.black15w600.copyWith(
                                            color: AppColors.blueColorA,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                WidthSpace(12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context
                                        .read<JustificatifsCubit>()
                                        .deletejustificatif(id),
                                    child: Container(
                                      height: 46.h,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Supprimer',
                                          style: AppStyles.black15w600.copyWith(
                                            color: AppColors.whiteColor,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suivi des justificatifs", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              HeightSpace(16),
              Expanded(
                child: BlocBuilder<JustificatifsCubit, JustificationState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return ListView.builder(
                        itemCount: 6,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: ShimmerEffect(
                              baseColor: AppColors.greyColor,
                              highlightColor: AppColors.lightGreyColor,
                              child: Container(
                                padding: EdgeInsets.all(20.sp),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 130.w,
                                          height: 18.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 70.w,
                                          height: 28.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    HeightSpace(10),
                                    Container(
                                      width: 100.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    HeightSpace(8),
                                    Container(
                                      width: 120.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    HeightSpace(6),
                                    Container(
                                      width: 160.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    HeightSpace(14),
                                    Container(
                                      width: 180.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    HeightSpace(6),
                                    Container(
                                      width: 140.w,
                                      height: 13.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    HeightSpace(21),
                                    Container(
                                      width: 120.w,
                                      height: 15.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (state is ErrorState) {
                      return AucuneJustificationWidget(
                        Title1: "Une erreur est survenue",
                        Title2:
                            "Veuillez vérifier votre connexion et réessayer",
                      );
                    }

                    if (state is LoadedState) {
                      final List<Justification> justificatifsData =
                          state.products;

                      if (justificatifsData.isEmpty) {
                        return Column(
                          children: [
                            Expanded(
                              child: AucuneJustificationWidget(
                                Title1: "Aucune Justificatif pour le moment",
                                Title2:
                                    "Vous serez informé dès qu'un changement survient.",
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.h,
                                horizontal: 26.w,
                              ),
                              child: Bottons(
                                textstyle: AppStyles.white15w700.copyWith(
                                  fontSize: 15.sp,
                                ),
                                title: "Nouveau justificatif",
                                onPress: _navigateToSubmit,
                              ),
                            ),
                          ],
                        );
                      }

                      return RefreshIndicator(
                        backgroundColor: AppColors.whiteColor,
                        color: AppColors.blueColorE,
                        onRefresh: () async => context
                            .read<JustificatifsCubit>()
                            .fetchjustificatifs(),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item = justificatifsData[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: JustificationCard(
                                    matieres: item.detailsMatieres
                                        .map((m) => m.nom)
                                        .toList(),
                                    date:
                                        "${_formatDate(item.dateAbsenceDebut)} - ${_formatDate(item.dateAbsenceFin)}",
                                    type: item.typeJustification,
                                    status: item.status,
                                    submissionDate: _formatDate(item.createdAt),
                                    commentaire: item.commentaire,
                                    showAdminComment: true,
                                    onPressmodifier: () {
                                      context.pushNamed(
                                        AppRoutes.editjustification,
                                        extra: {
                                          'id': item.id.toString(),
                                          'matiereIds': item.matiereIds,
                                          'datedebutAbsence': _formatDate(
                                            item.dateAbsenceDebut,
                                          ),
                                          'datefinAbsence': _formatDate(
                                            item.dateAbsenceFin,
                                          ),
                                          'typeJustification':
                                              item.typeJustification,
                                          'raisonAbsence': item.raison,
                                          'existingFilePath': item.fileUrl,
                                        },
                                      );
                                    },
                                    onPresssupprimer: () => _showDeleteDialog(
                                      context,
                                      item.id.toString(),
                                    ),
                                  ),
                                );
                              }, childCount: justificatifsData.length),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.h,
                                      horizontal: 26.w,
                                    ),
                                    child: Bottons(
                                      textstyle: AppStyles.white15w700.copyWith(
                                        fontSize: 15.sp,
                                      ),
                                      title: "Nouveau justificatif",
                                      onPress: _navigateToSubmit,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
