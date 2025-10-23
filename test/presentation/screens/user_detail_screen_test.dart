// 📄 test/presentation/screens/user_detail_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_event.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';
import 'package:technical_test_project/presentation/screens/user_detail_screen.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/entities/address.dart';

/// Fake para UserEvent requerido por mocktail
class FakeUserEvent extends Fake implements UserEvent {}

/// Mock del Bloc
class MockUserBloc extends Mock implements UserBloc {}

void main() {
  late MockUserBloc mockUserBloc;

  setUpAll(() {
    registerFallbackValue(FakeUserEvent());
  });

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  Widget makeTestable(Widget child) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => child,
        ),
        GoRoute(
          path: '/users',
          builder: (_, __) => const Scaffold(body: Text('Users list')),
        ),
        GoRoute(
          path: '/users/:id/edit',
          builder: (_, state) => Scaffold(
            body: Text('Edit user ${state.extra}'),
          ),
        ),
      ],
    );

    return BlocProvider<UserBloc>.value(
      value: mockUserBloc,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('UserDetailScreen', () {
    testWidgets('muestra indicador de carga cuando el estado es UserLoading',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(UserLoading());
      when(() => mockUserBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestable(const UserDetailScreen(userId: 1)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'muestra información del usuario cuando el estado es UserDetailLoaded',
        (tester) async {
      final user = User(
        id: 1,
        name: 'John',
        lastname: 'Doe',
        email: 'john@example.com',
        birthDate: '2000-01-01',
        addresses: const [
          Address(
              id: 1,
              country: 'México',
              state: 'CDMX',
              city: 'Ciudad',
              street: 'Calle 123'),
        ],
      );

      when(() => mockUserBloc.state).thenReturn(UserDetailLoaded(user));
      when(() => mockUserBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestable(UserDetailScreen(userId: user.id)));
      await tester.pumpAndSettle();

      expect(find.text('Información Personal'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Direcciones'), findsOneWidget);
      expect(find.textContaining('Calle 123'), findsOneWidget);
    });

    testWidgets('muestra mensaje de error y botón volver en estado UserError',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(UserError('Error al cargar'));
      when(() => mockUserBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestable(const UserDetailScreen(userId: 1)));
      await tester.pumpAndSettle();

      expect(find.text('Error al cargar'), findsOneWidget);
      expect(find.text('Volver'), findsOneWidget);
    });

    testWidgets(
        'muestra mensaje "No se encontró información del usuario" cuando el estado es otro',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(UserInitial());
      when(() => mockUserBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestable(const UserDetailScreen(userId: 1)));
      await tester.pumpAndSettle();

      expect(
          find.text('No se encontró información del usuario'), findsOneWidget);
    });

    testWidgets(
        'abre diálogo de eliminación y envía DeleteUserEvent al confirmar',
        (tester) async {
      final user = User(
        id: 2,
        name: 'Jane',
        lastname: 'Smith',
        email: 'jane@example.com',
        birthDate: '1995-01-01',
        addresses: const [],
      );

      when(() => mockUserBloc.state).thenReturn(UserDetailLoaded(user));
      when(() => mockUserBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockUserBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(makeTestable(UserDetailScreen(userId: user.id)));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Eliminar usuario'));
      await tester.pumpAndSettle();

      expect(find.text('Confirmar eliminación'), findsOneWidget);

      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      verify(() => mockUserBloc.add(any(that: isA<DeleteUserEvent>())))
          .called(1);
    });

    testWidgets(
        'navega a pantalla de edición cuando se presiona el botón editar',
        (tester) async {
      final user = User(
        id: 3,
        name: 'Mario',
        lastname: 'Rossi',
        email: 'mario@example.com',
        birthDate: '1990-01-01',
        addresses: const [],
      );

      when(() => mockUserBloc.state).thenReturn(UserDetailLoaded(user));
      when(() => mockUserBloc.stream).thenAnswer((_) => const Stream.empty());

      final router = GoRouter(
        initialLocation: '/users/3',
        routes: [
          GoRoute(
            path: '/users',
            builder: (_, __) => const Scaffold(body: Text('Users list')),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, __) => BlocProvider<UserBloc>.value(
                  value: mockUserBloc,
                  child: UserDetailScreen(userId: user.id),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) =>
                    Scaffold(body: Text('Edit user ${state.extra}')),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Editar usuario'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Edit user'), findsOneWidget);
    });
  });
}
