import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';

import '../../../auth/ui/widget/name_field_widget.dart';
import '../../../shared/ui/widget/pick_image_bottom_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? imgPathLocal;
  String? imgPathNetwork;
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser!.displayName != null) {
      _nameController.text = FirebaseAuth.instance.currentUser!.displayName!;
    }
    if (FirebaseAuth.instance.currentUser!.photoURL != null) {
      imgPathNetwork = FirebaseAuth.instance.currentUser!.photoURL;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                SizedBox(height: 12.h),
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
                                  imgPathLocal = value?.path;
                                });
                              });
                            }));
                  },
                  child: Hero(
                    tag: 'profile',
                    child: CircleAvatar(
                      radius: 50,
                      foregroundImage: imgPathLocal == null
                          ? imgPathNetwork == null
                              ? null
                              : NetworkImage(imgPathNetwork!)
                          : FileImage(File(imgPathLocal!)) as ImageProvider,
                      child: imgPathLocal == null && imgPathNetwork == null
                          ? Icon(
                              Icons.add_a_photo_outlined,
                              size: 24.sp,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                NameFieldWidget(nameController: _nameController),
                SizedBox(height: 1.h),
                context.watch<AuthProvider>().isLoading
                    ? const RefreshProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<AuthProvider>()
                              .updateUser(_nameController.text, imgPathLocal);
                          if(mounted) {
                            Navigator.pop(context);
                          }
                          if(mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Update'),
                      ),
              ],
            ),
          ),
        ));
  }
}
