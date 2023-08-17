import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nurserygardenapp/helper/route_helper.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/providers/splash_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await di.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<PlantProvider>()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = new GlobalKey<NavigatorState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouterHelper.setupRoute();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return MaterialApp(
          initialRoute: Routes.getSplashRoute(),
          onGenerateRoute: RouterHelper.router.generator,
          title: AppConstants.APP_NAME,
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
          theme: ThemeData().copyWith(
              colorScheme:
                  ColorScheme.light().copyWith(background: Colors.white),
              primaryColor: Color.fromARGB(255, 30, 133, 104),
              useMaterial3: true),
        );
      },
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)..maxConnectionsPerHost = 5;
//   }
// }
