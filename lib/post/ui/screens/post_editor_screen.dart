import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/ui/widget/pick_image_bottom_sheet.dart';

import '../widget/content_field_widget.dart';
import '../widget/title_field_widget.dart';

class PostEditorScreen extends StatefulWidget {
  PostModel? postModel;
  PostEditorScreen({
    Key? key,
    this.postModel,
  }) : super(key: key);

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  String? imgPath;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.postModel != null) {
      titleController.text = widget.postModel!.title;
      contentController.text = widget.postModel!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Editor'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
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
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      height: 20.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                      child: imgPath == null
                          ? widget.postModel != null
                              ? Image.network(
                                  widget.postModel!.photoUrl,
                                  height: 20.h,
                                  width: 60.w,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 26.sp,
                                )
                          : Image.file(
                              File(imgPath!),
                              height: 20.h,
                              width: 60.w,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  TitleFieldWidget(titleController: titleController),
                  ContentFieldWidget(contentController: contentController),
                  Consumer<PostProvider>(builder: (context, value, wid) {
                    return value.isUpLoading
                        ? RefreshProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              if (imgPath == null && widget.postModel == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select an image'),
                                  ),
                                );
                                return;
                              }
                              try {
                                User user = FirebaseAuth.instance.currentUser!;
                                PostModel postModel = PostModel(
                                  uid: '',
                                  title: titleController.text,
                                  content: contentController.text,
                                  photoUrl: imgPath ?? '',
                                  createdAt: DateTime.now(),
                                  createdByUid: user.uid,
                                );
                                if (widget.postModel != null) {
                                  postModel.uid = widget.postModel!.uid;
                                  postModel.photoUrl =
                                      widget.postModel!.photoUrl;

                                  await context
                                      .read<PostProvider>()
                                      .updatePost(postModel, imgPath);
                                } else {
                                  await context.read<PostProvider>().createPost(
                                        postModel,
                                      );
                                }
                                Navigator.pop(context);
                              } on FirebaseException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message!),
                                  ),
                                );
                              }
                            },
                            child: Text(widget.postModel != null
                                ? 'Update Post'
                                : 'Create Post'),
                          );
                  })
                ],
              ),
            ),
          ),
        ));
  }
}
