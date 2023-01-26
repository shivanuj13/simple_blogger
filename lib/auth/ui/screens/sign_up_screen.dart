import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? imgPath;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
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
                  await value.insertUser(
                      UserModel(
                          uid: '',
                          name: nameController.text,
                          email: emailController.text,
                          photoUrl: imgPath ?? '',
                          joinedAt: DateTime.now()),
                      passwordController.text);
                }
                Navigator.pushReplacementNamed(context, RouteConst.home);
              },
              child: value.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up'),
            );
          }),
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
