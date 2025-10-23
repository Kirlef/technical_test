import 'package:flutter_test/flutter_test.dart';
import 'package:technical_test_project/domain/entities/address.dart';

void main() {
  group('Address Entity', () {
    test('debe crear correctamente una instancia', () {
      const address = Address(
        id: 1,
        country: 'Colombia',
        state: 'Valle del Cauca',
        city: 'Jamundí',
        street: 'Calle 10 #25-50',
      );

      expect(address.id, 1);
      expect(address.country, 'Colombia');
      expect(address.state, 'Valle del Cauca');
      expect(address.city, 'Jamundí');
      expect(address.street, 'Calle 10 #25-50');
    });

    test('dos direcciones iguales con los mismos datos deberían ser iguales',
        () {
      const a1 = Address(
        id: 1,
        country: 'Colombia',
        state: 'Valle del Cauca',
        city: 'Jamundí',
        street: 'Calle 10 #25-50',
      );
      const a2 = Address(
        id: 1,
        country: 'Colombia',
        state: 'Valle del Cauca',
        city: 'Jamundí',
        street: 'Calle 10 #25-50',
      );

      expect(a1, equals(a2));
    });
  });
}
