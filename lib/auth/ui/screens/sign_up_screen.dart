import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';
import 'package:simple_blog/shared/ui/widget/pick_image_bottom_sheet.dart';

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
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    PickImageBottomSheet.instance.show(context, (source) {
                      ImagePicker().pickImage(source: source).then((value) {
                        setState(() {
                          imgPath = value?.path;
                        });
                      });
                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    foregroundImage: imgPath == null
                        ? null
                        : FileImage(File(imgPath!)) as ImageProvider,
                    child: imgPath == null
                        ? Icon(
                            Icons.add_a_photo_outlined,
                            size: 24.sp,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 6.h),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      gapPadding: 0,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
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
                SizedBox(height: 2.h),
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
                SizedBox(height: 6.h),
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
                      Navigator.pushReplacementNamed(
                          context, RouteConst.signIn);
                    },
                    child: const Text('Already have an account? Sign In')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
