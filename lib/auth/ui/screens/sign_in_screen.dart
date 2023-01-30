import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await context
          .read<AuthProvider>()
          .signIn(emailController.text, passwordController.text);
      Navigator.pushReplacementNamed(context, RouteConst.home);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  EmailFieldWidget(
                    emailController: emailController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  PasswordFieldWidget(passwordController: passwordController),
                  SizedBox(
                    height: 6.h,
                  ),
                  Consumer<AuthProvider>(builder: (context, value, wid) {
                    return value.isLoading
                        ? const RefreshProgressIndicator()
                        : ElevatedButton(
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
        ),
      ),
    );
  }
}
