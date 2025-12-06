import 'package:flutter/material.dart';
import 'package:parking/src/module/home/controller/home_controller.dart';
import 'package:parking/src/module/home/page/home_page.dart';
import 'package:parking/src/module/splash/page/splash_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: HomeController())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrintPark',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.teal),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,

      routes: {
        Routes.splash: (context) => SplashPage(),
        Routes.home: (context) => HomePage(),
      },
    );
  }
}

abstract class Routes {
  static String splash = '/splash';
  static String home = '/home';
}
