import 'package:flutter/material.dart';
import 'package:hamsa_flutter/views/add_task_view.dart';
import 'package:hamsa_flutter/views/home_view.dart';
import 'package:hamsa_flutter/views/login_view.dart';
import 'package:hamsa_flutter/views/profile_view.dart';
import 'package:hamsa_flutter/views/signup_view.dart';

// Maintain a mapping from route back to enum
// Only work for static route name
final Map<String, AppRoute> _routeNameToEnum = {};
typedef RouteGeneratorCallback = Route<dynamic>? Function(RouteSettings)?;

final _routes = <String, Widget Function()>{
  AppRoute.login.name: () => const LoginView(),
  AppRoute.signup.name: () => const SignUpView(),
  AppRoute.home.name: () => const HomeView(),
  AppRoute.addTask.name: () => const AddTaskView(),
  AppRoute.userProfile.name: () => const ProfileView(),
};

enum AppRoute {
  login("/login"),
  signup("/signup"),
  home("/home"),
  addTask("/taskAdd"),
  userProfile("/me");

  final String name;

  const AppRoute(this.name);

  static AppRoute fromName(String name) {
    return _routeNameToEnum[name]!;
  }
}

void registerStaticAppRoute() {
  for (var r in AppRoute.values) {
    _routeNameToEnum[r.name] = r;
  }
}

RouteGeneratorCallback generateRoute = (settings) {
  if (_routes.containsKey(settings.name)) {
    return MaterialPageRoute(
      builder: (context) {
        return _routes[settings.name]!();
      },
    );
  }

  // Unknown route fallback
  // return MaterialPageRoute(builder: (_) => const UnknownRoutePage());
  throw Exception('unknown route');
};
