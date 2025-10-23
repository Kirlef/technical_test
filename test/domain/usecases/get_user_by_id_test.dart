import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/get_user_by_id.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late GetUserById usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = GetUserById(repository);
  });

  test('debe retornar un usuario por id', () async {
    const user =
        User(id: 1, name: 'Juan', lastname: 'Pérez', email: 'jp@test.com');

    when(() => repository.getUserById(1)).thenAnswer((_) async => user);

    final result = await usecase(1);

    expect(result, equals(user));
    verify(() => repository.getUserById(1)).called(1);
  });
}
