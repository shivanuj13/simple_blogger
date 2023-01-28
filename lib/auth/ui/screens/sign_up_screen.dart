import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';
import 'package:simple_blog/shared/ui/widget/pick_image_bottom_sheet.dart';

import '../widget/email_field_widget.dart';
import '../widget/name_field_widget.dart';
import '../widget/password_field_widget.dart';

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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              PickImageBottomSheet(onImageSelected: (source) {
                                ImagePicker()
                                    .pickImage(source: source)
                                    .then((value) {
                                  setState(() {
                                    imgPath = value?.path;
                                  });
                                });
                              }));
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
                  NameFieldWidget(nameController: nameController),
                  EmailFieldWidget(emailController: emailController),
                  PasswordFieldWidget(passwordController: passwordController),
                  SizedBox(height: 6.h),
                  Consumer<AuthProvider>(builder: (context, value, wid) {
                    return value.isLoading
                        ? const RefreshProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (imgPath == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please select an image')));
                                  return;
                                }
                                try {
                                  await value.insertUser(
                                      UserModel(
                                          uid: '',
                                          name: nameController.text,
                                          email: emailController.text,
                                          photoUrl: imgPath ?? '',
                                          joinedAt: DateTime.now()),
                                      passwordController.text);
                                  Navigator.pushReplacementNamed(
                                      context, RouteConst.home);
                                } on FirebaseAuthException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message ?? '')));
                                }
                              }
                            },
                            child: const Text('Sign Up'),
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
      ),
    );
  }
}
