import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/delete_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late DeleteUser usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = DeleteUser(repository);
  });

  test('debe eliminar el usuario con el id correcto', () async {
    when(() => repository.deleteUser(1)).thenAnswer((_) async {});

    await usecase(1);

    verify(() => repository.deleteUser(1)).called(1);
  });
}
