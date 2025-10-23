import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/presentation/screens/user_list_screen.dart';

class MockUserBloc extends Mock implements UserBloc {}

void main() {
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<UserBloc>.value(
        value: mockUserBloc,
        child: child,
      ),
    );
  }

  testWidgets('muestra loading cuando el estado es UserLoading',
      (tester) async {
    // Mock de estado actual
    when(() => mockUserBloc.state).thenReturn(UserLoading());
    // Mock del stream que emite el mismo estado
    when(() => mockUserBloc.stream)
        .thenAnswer((_) => Stream.value(UserLoading()));

    await tester.pumpWidget(makeTestable(const UserListScreen()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('muestra lista de usuarios cuando el estado es UserLoaded',
      (tester) async {
    final users = [
      User(id: 1, name: 'Juan', email: 'juan@test.com', lastname: 'Diaz'),
      User(id: 2, name: 'Ana', email: 'ana@test.com', lastname: 'Solis'),
    ];

    when(() => mockUserBloc.state).thenReturn(UserLoaded(users));
    when(() => mockUserBloc.stream)
        .thenAnswer((_) => Stream.value(UserLoaded(users)));

    await tester.pumpWidget(makeTestable(const UserListScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Juan'), findsOneWidget);
    expect(find.text('Ana'), findsOneWidget);
  });
}
