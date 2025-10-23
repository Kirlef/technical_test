import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/entities/address.dart';
import 'package:technical_test_project/presentation/molecules/user_card.dart';
import 'package:technical_test_project/presentation/molecules/empty_state.dart';
import 'package:technical_test_project/presentation/organism/user_list.dart';
import 'package:technical_test_project/presentation/organism/user_form.dart';
import 'package:technical_test_project/presentation/organism/address_picker.dart';
import 'package:technical_test_project/presentation/molecules/address_tile.dart';

final testUser = User(
  id: 5,
  name: 'Juan',
  lastname: 'Pérez',
  email: 'juan@correo.com',
  birthDate: "1990/01/01",
  addresses: [
    Address(
      id: 6,
      country: 'Colombia',
      state: 'Antioquia',
      city: 'Medellín',
      street: 'Calle 123',
    )
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Smoke tests de widgets principales', () {
    testWidgets('UserCard muestra información del usuario', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(
              user: testUser,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Juan'), findsOneWidget);
      expect(find.text('juan@correo.com'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('UserList muestra EmptyState cuando no hay usuarios',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserList(users: []),
          ),
        ),
      );

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('Sin usuarios'), findsOneWidget);
    });

    testWidgets('UserList muestra UserCard cuando hay usuarios',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserList(users: [testUser]),
          ),
        ),
      );

      expect(find.byType(UserCard), findsOneWidget);
      expect(find.text('Juan'), findsOneWidget);
    });

    testWidgets('AddressTile muestra dirección y ciudad', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressTile(
              address: 'Calle 123',
              city: 'Medellín',
            ),
          ),
        ),
      );

      expect(find.text('Calle 123'), findsOneWidget);
      expect(find.text('Medellín'), findsOneWidget);
    });

    testWidgets('SelectStatePicker se construye sin errores iniciales',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectStatePicker(
              onCountryChanged: (_) {},
              onStateChanged: (_) {},
              onCityChanged: (_) {},
            ),
          ),
        ),
      );

      // No debería lanzar errores al construir
      expect(find.byType(SelectStatePicker), findsOneWidget);
    });
  });
}
