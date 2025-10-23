import 'package:flutter_test/flutter_test.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/entities/address.dart';

void main() {
  group('User Entity', () {
    test('debe crear correctamente una instancia con direcciones', () {
      const address = Address(
        id: 1,
        country: 'Colombia',
        state: 'Valle del Cauca',
        city: 'Jamundí',
        street: 'Calle 10 #25-50',
      );

      const user = User(
        id: 1,
        name: 'Juan',
        lastname: 'Pérez',
        email: 'juan@email.com',
        birthDate: '1990-01-01',
        addresses: [address],
      );

      expect(user.id, 1);
      expect(user.name, 'Juan');
      expect(user.lastname, 'Pérez');
      expect(user.email, 'juan@email.com');
      expect(user.addresses.length, 1);
      expect(user.addresses.first.city, 'Jamundí');
    });
  });
}
