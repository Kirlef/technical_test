import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:technical_test_project/presentation/atoms/atoms.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';
import 'package:technical_test_project/presentation/molecules/molecules.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded && state.users.isNotEmpty) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (_, i) => UserCard(
                user: state.users[i],
                onTap: () {
                  context.go('/users/${state.users[i].id}');
                },
              ),
            );
          } else {
            return const EmptyState(message: 'No hay usuarios registrados', title: '',);
          }
        },
      ),
      floatingActionButton: AppButton(
        label: 'Agregar usuario',
        onPressed: () {
          context.go('/users/add');
        },
      ),
    );
  }
}
