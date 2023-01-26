import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Column(
        children: [
          Text('Sign In Screen'),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          Consumer<AuthProvider>(builder: (context, value, wid) {
            return ElevatedButton(
              onPressed: () async {
                if (!value.isLoading) {
                  await value.signIn(
                      emailController.text, passwordController.text);
                }
                Navigator.pushReplacementNamed(context, RouteConst.home);
              },
              child: value.isLoading
                  ? CircularProgressIndicator()
                  : const Text('Sign In'),
            );
          }),
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, RouteConst.signUp);
              },
              child: const Text('Don\'t have an account? Sign Up')),
        ],
      ),
    );
  }
}
