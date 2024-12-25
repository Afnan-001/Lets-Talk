import 'package:flutter/material.dart';

//Providers


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Pages
import './pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GDSC_Community",
        theme: ThemeData(
          dialogBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 27, 1.0),
          ),
        ),
        debugShowCheckedModeBanner: false, home: const SplashPage());
  }
}
