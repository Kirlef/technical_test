import 'package:flutter_test/flutter_test.dart';
import 'package:technical_test_project/data/models/address_model.dart';
import 'package:technical_test_project/data/models/user_model.dart';
import 'package:technical_test_project/domain/entities/user.dart';

void main() {
  final addressJson = {
    'id': 1,
    'country': 'Colombia',
    'state': 'Valle',
    'city': 'Jamundí',
    'street': 'Calle 123',
  };

  final userJson = {
    'id': 10,
    'name': 'Mauricio',
    'lastname': 'Díaz',
    'email': 'test@test.com',
    'addresses': [addressJson],
  };

  test('fromJson debería crear un modelo válido', () {
    final model = UserModel.fromJson(userJson);

    expect(model.name, 'Mauricio');
    expect(model.addresses.first.city, 'Jamundí');
  });

  test('toJson debería devolver un mapa válido', () {
    final model = UserModel.fromJson(userJson);
    final json = model.toJson();

    expect(json['name'], 'Mauricio');
    expect(json['addresses'], isA<List>());
  });

  test('fromEntity y toEntity deben convertir correctamente', () {
    final entity = User(
      id: 10,
      name: 'Ana',
      lastname: 'Gómez',
      email: 'ana@test.com',
      addresses: [
        AddressModel(
          id: 1,
          country: 'Colombia',
          state: 'Valle',
          city: 'Cali',
          street: 'Cra 15',
        ).toEntity(),
      ],
    );

    final model = UserModel.fromEntity(entity);
    final converted = model.toEntity();

    expect(converted.name, 'Ana');
    expect(converted.addresses.first.city, 'Cali');
  });
}
