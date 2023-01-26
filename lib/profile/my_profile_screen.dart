import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            Text(FirebaseAuth.instance.currentUser?.displayName ?? 'Name'),
            const Text('Email'),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteConst.editProfile);
                },
                child: const Text('Edit Profile')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteConst.myPosts);
                },
                child: const Text('My Posts')),
            TextButton(
                onPressed: () async {
                  await context.read<AuthProvider>().signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, RouteConst.signIn);
                },
                child: const Text('Log Out'))
          ],
        ),
      ),
    );
  }
}
