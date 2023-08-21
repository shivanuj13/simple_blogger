import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../widget/email_field_widget.dart';
import '../widget/password_field_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String greetingText() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  Future<void> signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await context
          .read<AuthProvider>()
          .signIn(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteConst.home);
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign In'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40.h,
              width: 100.w,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 155, 78, 52),
                    Color.fromARGB(255, 168, 54, 54),
                    Color.fromARGB(255, 148, 32, 32),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(
                    flex: 7,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/blog.png',
                      height: 10.h,
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 35.w,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        greetingText(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                      bottom: 4.h,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Welcome Back !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    EmailFieldWidget(
                      emailController: _emailController,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    PasswordFieldWidget(
                        passwordController: _passwordController),
                    SizedBox(
                      height: 6.h,
                    ),
                    Consumer<AuthProvider>(builder: (context, value, wid) {
                      return value.isLoading
                          ? const RefreshProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromWidth(
                                  40.w,
                                ),
                              ),
                              onPressed: signIn,
                              child: const Text('Sign In'),
                            );
                    }),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteConst.signUp);
                        },
                        child: const Text('Don\'t have an account? Sign Up')),
                  ].animate(interval: 80.ms).fadeIn().moveY(begin: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
