import 'package:flutter/material.dart';
import 'package:technical_test_project/app.dart';
import 'package:technical_test_project/core/di/dependency_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies(); 
  runApp(const App());
}
