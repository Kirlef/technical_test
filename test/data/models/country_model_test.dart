import 'package:flutter_test/flutter_test.dart';
import 'package:technical_test_project/data/models/country_model.dart';

void main() {
  group('City Tests', () {
    test('constructor debe crear instancia con valores', () {
      final city = City(
        id: 1,
        name: 'Bogotá',
        stateId: 10,
      );

      expect(city.id, 1);
      expect(city.name, 'Bogotá');
      expect(city.stateId, 10);
    });

    test('constructor debe permitir valores null', () {
      final city = City();

      expect(city.id, isNull);
      expect(city.name, isNull);
      expect(city.stateId, isNull);
    });

    test('fromJson debe parsear correctamente un JSON completo', () {
      final json = {
        'id': 1,
        'name': 'Medellín',
        'state_id': 20,
      };

      final city = City.fromJson(json);

      expect(city.id, 1);
      expect(city.name, 'Medellín');
      expect(city.stateId, 20);
    });

    test('fromJson debe manejar valores null', () {
      final json = <String, dynamic>{
        'id': null,
        'name': null,
        'state_id': null,
      };

      final city = City.fromJson(json);

      expect(city.id, isNull);
      expect(city.name, isNull);
      expect(city.stateId, isNull);
    });

    test('fromJson debe manejar campos faltantes', () {
      final json = <String, dynamic>{};

      final city = City.fromJson(json);

      expect(city.id, isNull);
      expect(city.name, isNull);
      expect(city.stateId, isNull);
    });

    test('toJson debe serializar correctamente todos los campos', () {
      final city = City(
        id: 1,
        name: 'Cali',
        stateId: 30,
      );

      final json = city.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Cali');
      expect(json['state_id'], 30);
    });

    test('toJson debe incluir valores null', () {
      final city = City();

      final json = city.toJson();

      expect(json.containsKey('id'), isTrue);
      expect(json['id'], isNull);
      expect(json.containsKey('name'), isTrue);
      expect(json['name'], isNull);
      expect(json.containsKey('state_id'), isTrue);
      expect(json['state_id'], isNull);
    });

    test('fromJson y toJson deben ser simétricos', () {
      final originalJson = {
        'id': 5,
        'name': 'Barranquilla',
        'state_id': 40,
      };

      final city = City.fromJson(originalJson);
      final resultJson = city.toJson();

      expect(resultJson, originalJson);
    });
  });

  group('State Tests', () {
    test('constructor debe crear instancia con valores', () {
      final state = State(
        id: 1,
        name: 'Cundinamarca',
        countryId: 100,
        city: [
          City(id: 1, name: 'Bogotá', stateId: 1),
        ],
      );

      expect(state.id, 1);
      expect(state.name, 'Cundinamarca');
      expect(state.countryId, 100);
      expect(state.city, isNotNull);
      expect(state.city!.length, 1);
    });

    test('constructor debe permitir valores null', () {
      final state = State();

      expect(state.id, isNull);
      expect(state.name, isNull);
      expect(state.countryId, isNull);
      expect(state.city, isNull);
    });

    test('fromJson debe parsear correctamente un JSON completo con ciudades',
        () {
      final json = {
        'id': 1,
        'name': 'Antioquia',
        'country_id': 100,
        'city': [
          {'id': 1, 'name': 'Medellín', 'state_id': 1},
          {'id': 2, 'name': 'Envigado', 'state_id': 1},
        ],
      };

      final state = State.fromJson(json);

      expect(state.id, 1);
      expect(state.name, 'Antioquia');
      expect(state.countryId, 100);
      expect(state.city, isNotNull);
      expect(state.city!.length, 2);
      expect(state.city![0].name, 'Medellín');
      expect(state.city![1].name, 'Envigado');
    });

    test('fromJson debe parsear correctamente sin ciudades', () {
      final json = {
        'id': 2,
        'name': 'Valle del Cauca',
        'country_id': 100,
      };

      final state = State.fromJson(json);

      expect(state.id, 2);
      expect(state.name, 'Valle del Cauca');
      expect(state.countryId, 100);
      expect(state.city, isNull);
    });

    test('fromJson debe manejar lista de ciudades vacía', () {
      final json = {
        'id': 3,
        'name': 'Amazonas',
        'country_id': 100,
        'city': [],
      };

      final state = State.fromJson(json);

      expect(state.city, isNotNull);
      expect(state.city!.length, 0);
    });

    test('fromJson debe manejar city null', () {
      final json = {
        'id': 4,
        'name': 'Guainía',
        'country_id': 100,
        'city': null,
      };

      final state = State.fromJson(json);

      expect(state.city, isNull);
    });

    test('toJson debe serializar correctamente con ciudades', () {
      final state = State(
        id: 1,
        name: 'Atlántico',
        countryId: 100,
        city: [
          City(id: 1, name: 'Barranquilla', stateId: 1),
          City(id: 2, name: 'Soledad', stateId: 1),
        ],
      );

      final json = state.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Atlántico');
      expect(json['country_id'], 100);
      expect(json['city'], isNotNull);
      expect(json['city'].length, 2);
      expect(json['city'][0]['name'], 'Barranquilla');
      expect(json['city'][1]['name'], 'Soledad');
    });

    test('toJson debe manejar city null correctamente', () {
      final state = State(
        id: 1,
        name: 'Vaupés',
        countryId: 100,
      );

      final json = state.toJson();

      expect(json.containsKey('city'), isFalse);
    });

    test('toJson debe manejar lista de ciudades vacía', () {
      final state = State(
        id: 1,
        name: 'Guaviare',
        countryId: 100,
        city: [],
      );

      final json = state.toJson();

      expect(json['city'], isNotNull);
      expect(json['city'].length, 0);
    });

    test('fromJson y toJson deben ser simétricos', () {
      final originalJson = {
        'id': 1,
        'name': 'Bolívar',
        'country_id': 100,
        'city': [
          {'id': 1, 'name': 'Cartagena', 'state_id': 1},
        ],
      };

      final state = State.fromJson(originalJson);
      final resultJson = state.toJson();

      expect(resultJson, originalJson);
    });
  });

  group('CountryModel Tests', () {
    test('constructor debe crear instancia con valores', () {
      final country = CountryModel(
        id: 1,
        name: 'Colombia',
        emoji: '🇨🇴',
        emojiU: 'U+1F1E8 U+1F1F4',
        state: [
          State(id: 1, name: 'Cundinamarca', countryId: 1),
        ],
      );

      expect(country.id, 1);
      expect(country.name, 'Colombia');
      expect(country.emoji, '🇨🇴');
      expect(country.emojiU, 'U+1F1E8 U+1F1F4');
      expect(country.state, isNotNull);
      expect(country.state!.length, 1);
    });

    test('constructor debe permitir valores null', () {
      final country = CountryModel();

      expect(country.id, isNull);
      expect(country.name, isNull);
      expect(country.emoji, isNull);
      expect(country.emojiU, isNull);
      expect(country.state, isNull);
    });

    test('fromJson debe parsear correctamente un JSON completo', () {
      final json = {
        'id': 1,
        'name': 'Colombia',
        'emoji': '🇨🇴',
        'emojiU': 'U+1F1E8 U+1F1F4',
        'state': [
          {
            'id': 1,
            'name': 'Cundinamarca',
            'country_id': 1,
            'city': [
              {'id': 1, 'name': 'Bogotá', 'state_id': 1},
            ],
          },
          {
            'id': 2,
            'name': 'Antioquia',
            'country_id': 1,
            'city': [
              {'id': 2, 'name': 'Medellín', 'state_id': 2},
            ],
          },
        ],
      };

      final country = CountryModel.fromJson(json);

      expect(country.id, 1);
      expect(country.name, 'Colombia');
      expect(country.emoji, '🇨🇴');
      expect(country.emojiU, 'U+1F1E8 U+1F1F4');
      expect(country.state, isNotNull);
      expect(country.state!.length, 2);
      expect(country.state![0].name, 'Cundinamarca');
      expect(country.state![0].city!.length, 1);
      expect(country.state![1].name, 'Antioquia');
    });

    test('fromJson debe parsear correctamente sin estados', () {
      final json = {
        'id': 2,
        'name': 'México',
        'emoji': '🇲🇽',
        'emojiU': 'U+1F1F2 U+1F1FD',
      };

      final country = CountryModel.fromJson(json);

      expect(country.id, 2);
      expect(country.name, 'México');
      expect(country.emoji, '🇲🇽');
      expect(country.state, isNull);
    });

    test('fromJson debe manejar lista de estados vacía', () {
      final json = {
        'id': 3,
        'name': 'Argentina',
        'emoji': '🇦🇷',
        'emojiU': 'U+1F1E6 U+1F1F7',
        'state': [],
      };

      final country = CountryModel.fromJson(json);

      expect(country.state, isNotNull);
      expect(country.state!.length, 0);
    });

    test('fromJson debe manejar state null', () {
      final json = {
        'id': 4,
        'name': 'Chile',
        'emoji': '🇨🇱',
        'emojiU': 'U+1F1E8 U+1F1F1',
        'state': null,
      };

      final country = CountryModel.fromJson(json);

      expect(country.state, isNull);
    });

    test('fromJson debe manejar valores null en campos básicos', () {
      final json = <String, dynamic>{
        'id': null,
        'name': null,
        'emoji': null,
        'emojiU': null,
      };

      final country = CountryModel.fromJson(json);

      expect(country.id, isNull);
      expect(country.name, isNull);
      expect(country.emoji, isNull);
      expect(country.emojiU, isNull);
    });

    test('toJson debe serializar correctamente con estados y ciudades', () {
      final country = CountryModel(
        id: 1,
        name: 'Colombia',
        emoji: '🇨🇴',
        emojiU: 'U+1F1E8 U+1F1F4',
        state: [
          State(
            id: 1,
            name: 'Valle del Cauca',
            countryId: 1,
            city: [
              City(id: 1, name: 'Cali', stateId: 1),
              City(id: 2, name: 'Palmira', stateId: 1),
            ],
          ),
        ],
      );

      final json = country.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Colombia');
      expect(json['emoji'], '🇨🇴');
      expect(json['emojiU'], 'U+1F1E8 U+1F1F4');
      expect(json['state'], isNotNull);
      expect(json['state'].length, 1);
      expect(json['state'][0]['name'], 'Valle del Cauca');
      expect(json['state'][0]['city'].length, 2);
      expect(json['state'][0]['city'][0]['name'], 'Cali');
    });

    test('toJson debe manejar state null correctamente', () {
      final country = CountryModel(
        id: 1,
        name: 'Perú',
        emoji: '🇵🇪',
        emojiU: 'U+1F1F5 U+1F1EA',
      );

      final json = country.toJson();

      expect(json.containsKey('state'), isFalse);
    });

    test('toJson debe manejar lista de estados vacía', () {
      final country = CountryModel(
        id: 1,
        name: 'Venezuela',
        emoji: '🇻🇪',
        emojiU: 'U+1F1FB U+1F1EA',
        state: [],
      );

      final json = country.toJson();

      expect(json['state'], isNotNull);
      expect(json['state'].length, 0);
    });

    test('toJson debe incluir valores null', () {
      final country = CountryModel();

      final json = country.toJson();

      expect(json['id'], isNull);
      expect(json['name'], isNull);
      expect(json['emoji'], isNull);
      expect(json['emojiU'], isNull);
    });

    test('fromJson y toJson deben ser simétricos - caso complejo', () {
      final originalJson = {
        'id': 1,
        'name': 'Colombia',
        'emoji': '🇨🇴',
        'emojiU': 'U+1F1E8 U+1F1F4',
        'state': [
          {
            'id': 1,
            'name': 'Atlántico',
            'country_id': 1,
            'city': [
              {'id': 1, 'name': 'Barranquilla', 'state_id': 1},
              {'id': 2, 'name': 'Soledad', 'state_id': 1},
            ],
          },
        ],
      };

      final country = CountryModel.fromJson(originalJson);
      final resultJson = country.toJson();

      expect(resultJson, originalJson);
    });

    test('fromJson y toJson deben ser simétricos - caso simple', () {
      final originalJson = {
        'id': 2,
        'name': 'Brasil',
        'emoji': '🇧🇷',
        'emojiU': 'U+1F1E7 U+1F1F7',
      };

      final country = CountryModel.fromJson(originalJson);
      final resultJson = country.toJson();

      expect(resultJson['id'], originalJson['id']);
      expect(resultJson['name'], originalJson['name']);
      expect(resultJson['emoji'], originalJson['emoji']);
      expect(resultJson['emojiU'], originalJson['emojiU']);
    });
  });

  group('Integración - Estructura completa', () {
    test('debe manejar correctamente una jerarquía completa de datos', () {
      final json = {
        'id': 1,
        'name': 'Colombia',
        'emoji': '🇨🇴',
        'emojiU': 'U+1F1E8 U+1F1F4',
        'state': [
          {
            'id': 1,
            'name': 'Cundinamarca',
            'country_id': 1,
            'city': [
              {'id': 1, 'name': 'Bogotá', 'state_id': 1},
              {'id': 2, 'name': 'Soacha', 'state_id': 1},
              {'id': 3, 'name': 'Zipaquirá', 'state_id': 1},
            ],
          },
          {
            'id': 2,
            'name': 'Antioquia',
            'country_id': 1,
            'city': [
              {'id': 4, 'name': 'Medellín', 'state_id': 2},
              {'id': 5, 'name': 'Bello', 'state_id': 2},
            ],
          },
          {
            'id': 3,
            'name': 'Valle del Cauca',
            'country_id': 1,
            'city': [
              {'id': 6, 'name': 'Cali', 'state_id': 3},
            ],
          },
        ],
      };

      final country = CountryModel.fromJson(json);

      // Verificar país
      expect(country.id, 1);
      expect(country.name, 'Colombia');
      expect(country.emoji, '🇨🇴');

      // Verificar estados
      expect(country.state!.length, 3);
      expect(country.state![0].name, 'Cundinamarca');
      expect(country.state![1].name, 'Antioquia');
      expect(country.state![2].name, 'Valle del Cauca');

      // Verificar ciudades de Cundinamarca
      expect(country.state![0].city!.length, 3);
      expect(country.state![0].city![0].name, 'Bogotá');
      expect(country.state![0].city![1].name, 'Soacha');

      // Verificar ciudades de Antioquia
      expect(country.state![1].city!.length, 2);
      expect(country.state![1].city![0].name, 'Medellín');

      // Verificar ciudades de Valle del Cauca
      expect(country.state![2].city!.length, 1);
      expect(country.state![2].city![0].name, 'Cali');

      // Verificar simetría
      final resultJson = country.toJson();
      expect(resultJson, json);
    });

    test('debe manejar estructura parcial sin errores', () {
      final json = {
        'id': 1,
        'name': 'Colombia',
        'state': [
          {
            'id': 1,
            'name': 'Estado sin ciudades',
            'country_id': 1,
          },
          {
            'id': 2,
            'name': 'Estado con ciudades',
            'country_id': 1,
            'city': [
              {'id': 1, 'name': 'Ciudad 1', 'state_id': 2},
            ],
          },
        ],
      };

      final country = CountryModel.fromJson(json);

      expect(country.state!.length, 2);
      expect(country.state![0].city, isNull);
      expect(country.state![1].city, isNotNull);
      expect(country.state![1].city!.length, 1);
    });
  });
}
