import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:technical_test_project/core/di/dependency_injector.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_event.dart';
import 'package:technical_test_project/presentation/screens/user_detail_screen.dart';
import 'package:technical_test_project/presentation/screens/user_form_screen.dart';
import 'package:technical_test_project/presentation/screens/user_list_screen.dart';

class AppRouter {
  static final UserBloc _userBloc = sl<UserBloc>();

  static final GoRouter router = GoRouter(
    initialLocation: '/users',
    routes: [
      GoRoute(
        path: '/users',
        builder: (context, state) {
          _userBloc.add(LoadUsersEvent());

          return BlocProvider.value(
            value: _userBloc,
            child: const UserListScreen(),
          );
        },
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => BlocProvider.value(
              value: _userBloc,
              child: const UserFormScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (_) => sl<UserBloc>()..add(GetUserByIdEvent(id)),
                child: UserDetailScreen(userId: id),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final user = state.extra as User?;

                  return BlocProvider.value(
                    value: _userBloc,
                    child: UserFormScreen(
                      isEditing: true,
                      user: user,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
