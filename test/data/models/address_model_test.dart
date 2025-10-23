import 'package:flutter_test/flutter_test.dart';
import 'package:technical_test_project/data/models/address_model.dart';
import 'package:technical_test_project/domain/entities/address.dart';

void main() {
  final addressJson = {
    'id': 1,
    'country': 'Colombia',
    'state': 'Valle',
    'city': 'Jamundí',
    'street': 'Calle 123',
  };

  final addressEntity = Address(
    id: 1,
    country: 'Colombia',
    state: 'Valle',
    city: 'Jamundí',
    street: 'Calle 123',
  );

  test('fromJson debería crear un modelo válido', () {
    final model = AddressModel.fromJson(addressJson);

    expect(model.country, 'Colombia');
    expect(model.city, 'Jamundí');
  });

  test('toJson debería devolver un mapa válido', () {
    final model = AddressModel.fromEntity(addressEntity);
    final json = model.toJson();

    expect(json['country'], 'Colombia');
    expect(json['street'], 'Calle 123');
  });

  test('copyWith debería crear un nuevo objeto modificado', () {
    final model = AddressModel.fromEntity(addressEntity);
    final updated = model.copyWith(city: 'Cali');

    expect(updated.city, 'Cali');
    expect(updated.country, 'Colombia'); // sin cambios
  });
}
