# technical_test_project

# Proyecto Flutter

Este proyecto está desarrollado en **Flutter** y funciona completamente de manera **local**.  
No hay datasource remoto, por lo que **no se emplea un archivo `.env`** ni manejo de secretos o información sensible.

---

## Instalación de dependencias
flutter pub get

## Generar mocks
flutter pub run build_runner build --delete-conflicting-outputs

## Coverage Unit Test
flutter test --coverage

## Generar informe en html para visualizar cobertura de los test unitarios
genhtml coverage/lcov.info -o coverage/html

## Integration Test (No terminado)
flutter test integration_test/app_integration_test.dart