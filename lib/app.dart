import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';
import 'package:simple_blog/shared/route/route_generator.dart';

import 'auth/provider/auth_provider.dart';
import 'shared/util/shared_pref.dart';

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
        ChangeNotifierProvider(create: (context) => PostProvider())
      ],
      child: MaterialApp(
        initialRoute: SharedPref.instance.route,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme:
            ThemeData(useMaterial3: true, colorSchemeSeed: Color(0xFF2C003E)),
      ),
    );
  }
}
