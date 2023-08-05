import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                                    .pickImage(source: source, imageQuality: 20)
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
                  NameFieldWidget(nameController: _nameController),
                  EmailFieldWidget(emailController: _emailController),
                  PasswordFieldWidget(passwordController: _passwordController),
                  SizedBox(height: 6.h),
                  Consumer<AuthProvider>(builder: (context, value, wid) {
                    return value.isLoading
                        ? const RefreshProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(
                                40.w,
                              ),
                            ),
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
                                      id: '',
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      photoUrl: imgPath ?? '',
                                      createdAt: DateTime.now(),
                                    ),
                                    context,
                                  );
                                  if (mounted) {
                                    Navigator.pushReplacementNamed(
                                        context, RouteConst.home);
                                  }
                                } on Exception catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
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
                ].animate(interval: 80.ms).fadeIn().moveY(begin: 2.h),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
