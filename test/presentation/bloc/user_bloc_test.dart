import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/usecases/usecases.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_event.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockGetUserById extends Mock implements GetUserById {}

class MockAddUser extends Mock implements AddUser {}

class MockUpdateUser extends Mock implements UpdateUser {}

class MockDeleteUser extends Mock implements DeleteUser {}

void main() {
  late UserBloc userBloc;
  late MockGetUsers mockGetUsers;
  late MockGetUserById mockGetUserById;
  late MockAddUser mockAddUser;
  late MockUpdateUser mockUpdateUser;
  late MockDeleteUser mockDeleteUser;

  final testUser =
      User(id: 1, name: 'John', email: 'test@test.com', lastname: 'Doe');

  setUp(() {
    mockGetUsers = MockGetUsers();
    mockGetUserById = MockGetUserById();
    mockAddUser = MockAddUser();
    mockUpdateUser = MockUpdateUser();
    mockDeleteUser = MockDeleteUser();

    userBloc = UserBloc(
      getUsers: mockGetUsers,
      getUserById: mockGetUserById,
      addUser: mockAddUser,
      updateUser: mockUpdateUser,
      deleteUser: mockDeleteUser,
    );
  });

  group('UserBloc', () {
    blocTest<UserBloc, UserState>(
      'emite [UserLoading, UserLoaded] cuando LoadUsersEvent es exitoso',
      build: () {
        when(() => mockGetUsers()).thenAnswer((_) async => [testUser]);
        return userBloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [isA<UserLoading>(), isA<UserLoaded>()],
      verify: (_) {
        verify(() => mockGetUsers()).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'emite [UserLoading, UserError] cuando LoadUsersEvent falla',
      build: () {
        when(() => mockGetUsers()).thenThrow(Exception());
        return userBloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [isA<UserLoading>(), isA<UserError>()],
    );

    blocTest<UserBloc, UserState>(
      'emite [UserDetailLoaded] cuando GetUserByIdEvent encuentra usuario',
      build: () {
        when(() => mockGetUserById(1)).thenAnswer((_) async => testUser);
        return userBloc;
      },
      act: (bloc) => bloc.add(const GetUserByIdEvent(1)),
      expect: () => [isA<UserLoading>(), isA<UserDetailLoaded>()],
    );

    blocTest<UserBloc, UserState>(
      'emite [UserError] cuando GetUserByIdEvent no encuentra usuario',
      build: () {
        when(() => mockGetUserById(1)).thenAnswer((_) async => null);
        return userBloc;
      },
      act: (bloc) => bloc.add(const GetUserByIdEvent(1)),
      expect: () => [isA<UserLoading>(), isA<UserError>()],
    );

    blocTest<UserBloc, UserState>(
      'emite [UserLoaded] luego de AddUserEvent exitoso',
      build: () {
        when(() => mockAddUser(testUser)).thenAnswer((_) async {});
        when(() => mockGetUsers()).thenAnswer((_) async => [testUser]);
        return userBloc;
      },
      act: (bloc) => bloc.add(AddUserEvent(testUser)),
      expect: () => [isA<UserLoaded>()],
      verify: (_) {
        verify(() => mockAddUser(testUser)).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'emite [UserLoaded] luego de DeleteUserEvent exitoso',
      build: () {
        when(() => mockDeleteUser(1)).thenAnswer((_) async {});
        when(() => mockGetUsers()).thenAnswer((_) async => []);
        return userBloc;
      },
      act: (bloc) => bloc.add(const DeleteUserEvent(1)),
      expect: () => [isA<UserLoaded>()],
    );
  });
}
