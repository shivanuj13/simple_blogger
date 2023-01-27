import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
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
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      gapPadding: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    labelText: 'Password',
                    border: const OutlineInputBorder(
                      gapPadding: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Consumer<AuthProvider>(builder: (context, value, wid) {
                  return value.isLoading
                      ? const RefreshProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (!value.isLoading) {
                              await value.signIn(emailController.text,
                                  passwordController.text);
                            }
                            Navigator.pushReplacementNamed(
                                context, RouteConst.home);
                          },
                          child: const Text('Sign In'),
                        );
                }),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RouteConst.signUp);
                    },
                    child: const Text('Don\'t have an account? Sign Up')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
