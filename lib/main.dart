import 'package:flutter/material.dart';
import 'package:simple_blog/app.dart';
import 'package:simple_blog/shared/util/shared_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.instance.initialAuthHandler();
  runApp(const MyApp());
}
