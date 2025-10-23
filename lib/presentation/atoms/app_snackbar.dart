import 'package:flutter/material.dart';
import 'package:technical_test_project/presentation/foundations/foundations.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final backgroundColor = switch (type) {
      SnackbarType.success => AppColors.secondary,
      SnackbarType.error => AppColors.error,
      SnackbarType.info => AppColors.primary,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.body.copyWith(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}
