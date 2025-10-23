import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/foundations/theme.dart';
import 'package:technical_test_project/router/router.dart';
import 'package:technical_test_project/core/di/dependency_injector.dart' as di;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.router;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<UserBloc>())],
      child: MaterialApp.router(
        title: 'Technical Test Project',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routerConfig: _router,
      ),
    );
  }
}
