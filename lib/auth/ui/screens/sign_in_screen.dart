import 'package:flutter/material.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteConst.home);
            },
            child: const Text('Sign In'),
          ),
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
