import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:technical_test_project/presentation/atoms/atoms.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_event.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';
import 'package:technical_test_project/presentation/foundations/foundations.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const AppText('Detalle del usuario', type: AppTextType.h2),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar usuario',
                onPressed: () {
                  context.pop();
                  // Ahora state está disponible aquí
                  if (state is UserDetailLoaded) {
                    context.go('/users/$userId/edit', extra: state.user);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Eliminar usuario',
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, UserState state) {
    if (state is UserLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is UserDetailLoaded) {
      final user = state.user;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información personal
            _buildInfoCard(
              title: 'Información Personal',
              children: [
                _buildInfoRow('Nombre', user.name),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow('Apellido', user.lastname),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow('Correo', user.email),
                if (user.birthDate != null && user.birthDate!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoRow('Fecha de Nacimiento', user.birthDate!),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Direcciones
            _buildInfoCard(
              title: 'Direcciones',
              children: [
                if (user.addresses.isEmpty)
                  const AppText(
                    'No hay direcciones registradas',
                    type: AppTextType.caption,
                    color: AppColors.textSecondary,
                  )
                else
                  ...user.addresses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final address = entry.value;
                    return _buildAddressCard(index, address);
                  }).toList(),
              ],
            ),
          ],
        ),
      );
    }

    if (state is UserError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              state.message,
              type: AppTextType.body,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Volver',
              onPressed: () => context.go('/users'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppText('No se encontró información del usuario'),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Volver',
            onPressed: () => context.go('/users'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title, type: AppTextType.h1),
            const SizedBox(height: AppSpacing.md),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: AppText(
            '$label:',
            type: AppTextType.body,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: AppText(
            value,
            type: AppTextType.body,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(int index, dynamic address) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Dirección ${index + 1}',
            type: AppTextType.h2,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildAddressRow('País', address.country),
          const SizedBox(height: AppSpacing.xs),
          _buildAddressRow('Estado', address.state),
          const SizedBox(height: AppSpacing.xs),
          _buildAddressRow('Ciudad', address.city),
          if (address.street.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            _buildAddressRow('Calle', address.street),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: AppText(
            '$label:',
            type: AppTextType.caption,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: AppText(
            value,
            type: AppTextType.body,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const AppText(
          'Confirmar eliminación',
          type: AppTextType.h2,
        ),
        content: const AppText(
          '¿Estás seguro de que quieres eliminar este usuario? Esta acción no se puede deshacer.',
          type: AppTextType.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const AppText(
              'Cancelar',
              type: AppTextType.body,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<UserBloc>().add(DeleteUserEvent(userId));
              Navigator.of(dialogContext).pop();
              context.go('/users');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const AppText(
              'Eliminar',
              type: AppTextType.body,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
