// test/user_form_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:technical_test_project/domain/entities/address.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_event.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';
import 'package:technical_test_project/presentation/screens/user_form_screen.dart';

// ---- MOCKS ----
class MockUserBloc extends Mock implements UserBloc {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeUserState extends Fake implements UserState {}

class MockGoRouter extends Mock implements GoRouter {}

Widget makeTestable(Widget child, UserBloc mockBloc) {
  return MaterialApp(
    home: BlocProvider<UserBloc>.value(
      value: mockBloc,
      child: child,
    ),
  );
}

void main() {
  late MockUserBloc mockUserBloc;

  setUpAll(() {
    registerFallbackValue(FakeUserEvent());
    registerFallbackValue(FakeUserState());
  });

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  group('UserFormScreen', () {
    testWidgets(
        'muestra CircularProgressIndicator cuando está cargando en modo edición',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(UserLoading());
      when(() => mockUserBloc.stream)
          .thenAnswer((_) => Stream.value(UserLoading()));

      await tester.pumpWidget(makeTestable(
        const UserFormScreen(isEditing: true, user: null),
        mockUserBloc,
      ));

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('muestra formulario vacío cuando no está en modo edición',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(UserInitial());
      when(() => mockUserBloc.stream)
          .thenAnswer((_) => Stream.value(UserInitial()));

      await tester.pumpWidget(makeTestable(
        const UserFormScreen(isEditing: false),
        mockUserBloc,
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
