import 'package:flutter/material.dart';
import 'package:simple_blog/shared/route/route_const.dart';
import 'package:simple_blog/shared/route/route_generator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteConst.signIn,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(useMaterial3: true),
    );
  }
}
