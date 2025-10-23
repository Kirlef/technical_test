import 'package:flutter/material.dart';
import 'package:technical_test_project/presentation/foundations/foundations.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text('${user.name}', style: AppTypography.h1),
        subtitle: Text(user.email, style: AppTypography.body),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
