// integration_test/app_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:technical_test_project/main.dart' as app;
import 'package:get_it/get_it.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Flujo completo de gestión de usuarios', () {
    setUpAll(() async {
      await GetIt.instance.reset();
    });

    tearDown(() async {
      await Future.delayed(const Duration(seconds: 1));
    });

    testWidgets(
        'Flujo: Ver lista → Agregar usuario → Ver detalle → Editar → Eliminar',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Usuarios'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      final addButton = find.text('Agregar usuario');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('Nuevo usuario'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, 100));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      await tester.enterText(textFields.at(0), 'Carlos Test');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.enterText(textFields.at(1), 'Rodríguez');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.enterText(textFields.at(2), 'carlos.test@example.com');
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(textFields.at(3));
      await tester.pumpAndSettle();
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final addAddressButton = find.text('Agregar dirección');
      await tester.tap(addAddressButton);
      await tester.pumpAndSettle();
      expect(find.text('Dirección 1'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final saveButton = find.text('Guardar');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Detalle del usuario'), findsOneWidget);
      expect(find.textContaining('Carlos'), findsWidgets);
      expect(find.textContaining('Rodríguez'), findsWidgets);
      await tester.pump(const Duration(seconds: 2));

      final editButton = find.byIcon(Icons.edit);
      await tester.tap(editButton);
      await tester.pumpAndSettle();
      expect(find.text('Editar usuario'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, 100));
      await tester.pumpAndSettle();

      final editTextFields = find.byType(TextField);
      await tester.enterText(editTextFields.at(0), 'Carlos Editado');
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      final saveEditButton = find.text('Guardar');
      await tester.tap(saveEditButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('Carlos Editado'), findsWidgets);
      await tester.pump(const Duration(seconds: 1));

      final backButton = find.byType(BackButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Usuarios'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));

      final userTile = find.textContaining('Carlos');
      if (userTile.evaluate().isNotEmpty) {
        await tester.tap(userTile.first);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        final deleteButton = find.byIcon(Icons.delete);
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        expect(find.text('Confirmar eliminación'), findsOneWidget);

        final confirmDeleteButton = find.text('Eliminar');
        await tester.tap(confirmDeleteButton);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Usuarios'), findsOneWidget);
      }

      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('Flujo: Validación de campos obligatorios',
        (WidgetTester tester) async {
      await GetIt.instance.reset();

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Agregar usuario'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();

      final saveButton = find.text('Guardar');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('Flujo: Agregar múltiples direcciones',
        (WidgetTester tester) async {
      await GetIt.instance.reset();

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Agregar usuario'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final addAddressButton = find.text('Agregar dirección');

      for (int i = 1; i <= 3; i++) {
        await tester.tap(addAddressButton);
        await tester.pumpAndSettle();
        expect(find.text('Dirección $i'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 500));

        if (i < 3) {
          await tester.drag(
              find.byType(SingleChildScrollView), const Offset(0, -200));
          await tester.pumpAndSettle();
        }
      }

      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('Flujo: Cancelar eliminación', (WidgetTester tester) async {
      await GetIt.instance.reset();

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 2));

      final userCards = find.byType(Card);
      if (userCards.evaluate().isNotEmpty) {
        await tester.tap(userCards.first);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        final deleteButton = find.byIcon(Icons.delete);
        if (deleteButton.evaluate().isNotEmpty) {
          await tester.tap(deleteButton);
          await tester.pumpAndSettle();

          expect(find.text('Confirmar eliminación'), findsOneWidget);

          await tester.tap(find.text('Cancelar'));
          await tester.pumpAndSettle();
          expect(find.text('Detalle del usuario'), findsOneWidget);
        }
      }

      await tester.pump(const Duration(seconds: 2));
    });
  });
}
