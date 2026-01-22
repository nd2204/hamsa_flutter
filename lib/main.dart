import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'firebase_options.dart';

void main() async {
  registerStaticAppRoute();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoute.login.name,
      onGenerateRoute: generateRoute,
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
