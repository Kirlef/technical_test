import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/data/datasource/local/user_local_datasource.dart';
import 'package:technical_test_project/data/repositories/user_repository_impl.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class MockLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockLocalDataSource mockLocal;

  setUp(() {
    mockLocal = MockLocalDataSource();
    repository = UserRepositoryImpl(local: mockLocal);
  });

  test('getUsers debería mapear correctamente los datos desde el datasource',
      () async {
    when(() => mockLocal.getUsers()).thenAnswer((_) async => [
          {
            'id': 1,
            'name': 'Juan',
            'lastname': 'Pérez',
            'email': 'juan@test.com',
            'addresses': [],
          }
        ]);

    final result = await repository.getUsers();

    expect(result, isA<List<User>>());
    expect(result.first.name, 'Juan');
  });

  test('addUser debería invocar insertUser del datasource', () async {
    final user = User(
      id: 1,
      name: 'Ana',
      lastname: 'Gómez',
      email: 'ana@test.com',
      addresses: const [],
    );

    when(() => mockLocal.insertUser(any())).thenAnswer((_) async {});

    await repository.addUser(user);

    verify(() => mockLocal.insertUser(any(that: containsPair('name', 'Ana'))))
        .called(1);
  });
}
