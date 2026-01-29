import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/services/task_service.dart';
import 'package:hamsa_flutter/states/auth_state.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:hamsa_flutter/viewmodels/home_viewmodel.dart';
import 'package:hamsa_flutter/viewmodels/task_viewmodel.dart';
import 'package:hamsa_flutter/views/home_view.dart';
import 'package:hamsa_flutter/views/login_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'repositories/user_repo.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/signup_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'constants/app_constants.dart';

void main() async {
  registerStaticAppRoute();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup dependency injection
  configureDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(getIt<IAuthService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(getIt<IAuthService>()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ProfileViewModel(getIt<IAuthService>(), getIt<IUserRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(
            getIt<ITaskService>(),
            getIt<ITaskRepository>(),
            getIt<IUserRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              HomeViewModel(getIt<IAuthService>(), getIt<ITaskRepository>()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRoute,
      title: 'Hamsa Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
      ),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthState>(
      valueListenable: getIt<AuthStateNotifier>(),
      builder: (context, auth, _) {
        switch (auth.authStatus) {
          case AuthStatus.loading:
            return FullScreenLoading();
          case AuthStatus.unauthenticated:
            return const LoginView();
          case AuthStatus.authenticated:
            return const HomeView();
          case AuthStatus.error:
            throw auth.errorObj;
        }
      },
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
