import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/utils/service_locator.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/justificatifs/cubit/datails_state.dart';
import 'package:scolarite/features/justificatifs/cubit/deaitls_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/justificatif_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/justificatif_state.dart';
import 'package:scolarite/features/justificatifs/cubit/refus_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/valider_cubit.dart';
import 'package:scolarite/features/justificatifs/justificatif_detail.dart';
import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';

class JusticatifsScreen extends StatefulWidget {
  const JusticatifsScreen({super.key});

  @override
  State<JusticatifsScreen> createState() => _JusticatifsScreenState();
}

class _JusticatifsScreenState extends State<JusticatifsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? _globalError;
  VoidCallback? _retryCallback;

  void _setError(String message, VoidCallback retry) {
    if (_globalError != null) return;
    setState(() {
      _globalError = message;
      _retryCallback = retry;
    });
  }

  void _clearError() {
    if (_globalError == null) return;
    setState(() {
      _globalError = null;
      _retryCallback = null;
    });
  }

  void _retryAll() {
    _clearError();
    _searchController.clear();
    context.read<JustificatifsCubit>().fetchAllJustificatifs();
  }

  void showJustificatifDetails(
    JustificatifsCubit justificatifsCubit,
    JustificatifDetailsCubit detailsCubit,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Details",
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Center(
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: justificatifsCubit),
                BlocProvider.value(value: detailsCubit),
                BlocProvider(create: (_) => ValiderCubit(sl())),
                BlocProvider(create: (_) => sl<RefusCubit>()),
              ],
              child:
                  BlocBuilder<
                    JustificatifDetailsCubit,
                    JustificatifDetailsState
                  >(
                    builder: (context, state) {
                      if (state is JustificatifDetailsLoadingState) {
                        return const CircularProgressIndicator(
                          color: Color(0xff0B68FC),
                        );
                      }
                      if (state is JustificatifDetailsSuccessState) {
                        return JustificatifDetail(
                          justificatif: state.justificatif,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JustificatifsCubit, JustificatifsState>(
      listener: (context, state) {
        if (state is JustificatifsErrorState) {
          _setError(state.error, _retryAll);
        } else if (state is JustificatifsSuccessState) {
          _clearError();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 26.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  Text("Justificatifs", style: AppStyles.blueBBw800),
                  HeightSpace(25),

                  Container(
                    height: 50.h,
                    width: 300.w,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                      color: const Color(0xffF0F6FC),
                      borderRadius: BorderRadius.circular(54.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          context
                              .read<JustificatifsCubit>()
                              .fetchAllJustificatifs();
                        } else {
                          context
                              .read<JustificatifsCubit>()
                              .searchJustificatifs(value);
                        }
                      },
                      style: AppStyles.grey13Bold.copyWith(
                        fontSize: 12.sp,
                        color: const Color(0xff454545),
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_sharp),
                        hintText: "Rechercher par étudiant",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  HeightSpace(45),

                  Expanded(
                    child: _globalError != null
                        ? _ErrorState(
                            message: _globalError!,
                            onRetry: _retryCallback!,
                          )
                        : _buildTableBody(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTableBody() {
    return BlocBuilder<JustificatifsCubit, JustificatifsState>(
      builder: (context, state) {
        if (state is JustificatifsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff0B68FC)),
          );
        }

        if (state is JustificatifsSuccessState) {
          final data = state.justificatifs;

          // ── Empty state : tableau visible mais vide ──────────
          if (data.isEmpty) {
            return _buildTableShell(child: Center(child: _EmptyState()));
          }

          // ── Success : tableau rempli ─────────────────────────
          return _buildTableShell(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return buildRowFromApi(
                  context,
                  data[index],
                  (jCubit, dCubit) => showJustificatifDetails(jCubit, dCubit),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTableShell({required Widget child}) {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xffE3EDF8),
        border: Border.all(color: const Color(0xff828282)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.r),
          topRight: Radius.circular(26.r),
        ),
      ),
      child: Column(
        children: [
          // Header colonnes
          Row(
            children: [
              buildHeaderCell("Nom Etudiant"),
              buildHeaderCell("Niveau"),
              buildHeaderCell("Modules"),
              buildHeaderCell("Date Absence"),
              buildHeaderCell("Date Soumission"),
              buildHeaderCell("Type"),
              WidthSpace(40),
            ],
          ),
          const Divider(color: Color(0xff828282)),

          // Contenu variable
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250.w,
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0969BB).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42.sp,
              color: Colors.red.withOpacity(0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.grey20w500.copyWith(
                color: const Color(0xFF828282),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6095E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 48.sp,
          color: const Color(0xFF828282).withOpacity(0.5),
        ),
        SizedBox(height: 16.h),
        Text(
          "Aucun justificatif trouvé",
          style: AppStyles.grey20w500.copyWith(
            color: const Color(0xFF828282),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}


Widget buildRowFromApi(
  BuildContext context,
  JustificatifsModel e,
  Function(JustificatifsCubit, JustificatifDetailsCubit) onShowDetails,
) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xff828282))),
    ),
    child: Row(
      children: [
        Expanded(
          child: Center(
            child: Text(e.nomEtudiant ?? "", style: AppStyles.black45Bold12),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(e.niveau ?? "", style: AppStyles.black45Bold12),
          ),
        ),
        Expanded(
          child: Text(
            e.modules?.join("\n") ?? "",
            style: AppStyles.black45Bold12,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              formatDate(e.dateAbsenceDebut),
              style: AppStyles.black45Bold12,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              formatDate(e.dateSoumission),
              style: AppStyles.black45Bold12,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              e.type ?? "",
              style: AppStyles.black45Bold12.copyWith(
                color: getTypeColor(e.type ?? ""),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            context.read<JustificatifDetailsCubit>().fetchJustificatifDetails(
              e.id!,
            );
            onShowDetails(
              context.read<JustificatifsCubit>(),
              context.read<JustificatifDetailsCubit>(),
            );
          },
          icon: const Icon(Icons.arrow_forward, color: Color(0xff0B68FC)),
        ),
      ],
    ),
  );
}

String formatDate(DateTime? date) {
  if (date == null) return "";
  return DateFormat('yyyy-MM-dd').format(date);
}

Color getTypeColor(String type) {
  switch (type) {
    case "Séance normal":
      return const Color(0xff28B58D);
    case "Test":
      return const Color(0xff5883C9);
    case "Examen":
      return const Color(0xffCD7B7B);
    case "EMD":
      return const Color(0xffCD7B7B);
    default:
      return Colors.black;
  }
}

Widget buildHeaderCell(String text) {
  return Expanded(
    child: Center(
      child: Text(text, style: AppStyles.black45Bold.copyWith(fontSize: 14.sp)),
    ),
  );
}
