import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugnu_taxi/pages/authService.dart';
import 'package:sugnu_taxi/pages/splashScreen.dart';
import 'package:sugnu_taxi/pages/wrapper.dart';
import 'package:sugnu_taxi/service.dart/Service.dart';

import 'Model/taxi.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      StreamProvider<User?>.value(
        initialData: null,
        value: AuthService().user,
      ),
      StreamProvider<List<Taxi>>.value(
        initialData: const [],
        value: DatabaseService().taxis,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire cars',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        'profile': (context) => const Wrapper()
      },
    );
  }
}
