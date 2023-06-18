import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/route/route_generator.dart';
import 'package:google_fonts/google_fonts.dart';
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
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SharedPref.instance.route,
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
            textTheme: GoogleFonts.notoSansTextTheme(
              Theme.of(context).textTheme,
            ),
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF850E35),
              secondary: Color(0xFFEE6983),
              surface: Color(0xFFF7EFE5),
              background: Color(0xFFFFFBF5),
            ),
          ),
        );
      }),
    );
  }
}
