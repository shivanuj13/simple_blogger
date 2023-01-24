import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? imgPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Column(
        children: [
          Text('Sign Up Screen'),
          InkWell(
            onTap: () async {
              XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                imgPath = image?.path;
              });
            },
            child: CircleAvatar(
              radius: 50,
              foregroundImage: imgPath == null
                  ? const NetworkImage(
                      'https://img.icons8.com/fluency/48/null/gender-neutral-user.png')
                  : FileImage(File(imgPath!)) as ImageProvider,
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
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
            child: const Text('Sign Up'),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, RouteConst.signIn);
              },
              child: const Text('Already have an account? Sign In')),
        ],
      ),
    );
  }
}
