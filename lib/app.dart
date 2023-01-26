import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';
import 'package:simple_blog/shared/route/route_generator.dart';

import 'auth/provider/auth_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        initialRoute: RouteConst.signIn,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme:
            ThemeData(useMaterial3: true, colorSchemeSeed: Color(0xFF2C003E)),
      ),
    );
  }
}
