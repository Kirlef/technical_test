import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import '../molecules/user_card.dart';
import '../molecules/empty_state.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final void Function(User user)? onUserTap;

  const UserList({super.key, required this.users, this.onUserTap});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const EmptyState(
        title: 'Sin usuarios',
        message: 'Agrega un usuario para comenzar',
        icon: Icons.person_outline,
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) {
        final user = users[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: UserCard(user: user, onTap: () => onUserTap?.call(user)),
        );
      },
    );
  }
}
