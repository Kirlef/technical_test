// ignore_for_file: unreachable_switch_default
import 'package:flutter/material.dart';
import 'package:technical_test_project/presentation/foundations/foundations.dart';

enum AppTextType { h1, h2, body, caption }

class AppText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final TextAlign? align;
  final Color? color;
  final int? maxLines;
  final TextOverflow overflow;

  const AppText(
    this.text, {
    super.key,
    this.type = AppTextType.body,
    this.align,
    this.color,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  TextStyle _getStyle() {
    switch (type) {
      case AppTextType.h1:
        return AppTypography.h1.copyWith(color: color ?? AppColors.textPrimary);
      case AppTextType.h2:
        return AppTypography.body.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        );
      case AppTextType.caption:
        return AppTypography.body.copyWith(
          fontSize: 12,
          color: color ?? AppColors.textSecondary,
        );
      case AppTextType.body:
      default:
        return AppTypography.body.copyWith(
          color: color ?? AppColors.textPrimary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: _getStyle(),
    );
  }
}
