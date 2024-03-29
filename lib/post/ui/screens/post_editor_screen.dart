import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:simple_blog/post/model/post_model.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/ui/widget/pick_image_bottom_sheet.dart';

import '../widget/content_field_widget.dart';
import '../widget/title_field_widget.dart';

class PostEditorScreen extends StatefulWidget {
  final PostModel? postModel;
  const PostEditorScreen({
    Key? key,
    this.postModel,
  }) : super(key: key);

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  String? imgPath;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.postModel != null) {
      _titleController.text = widget.postModel!.title;
      _contentController.text = widget.postModel!.content;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Editor'),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 8.h,
          padding: EdgeInsets.zero,
          child: Consumer<PostProvider>(builder: (context, value, wid) {
            return value.isUpLoading
                ? Column(
                    children: [
                      const LinearProgressIndicator(),
                      const Spacer(),
                      Text(
                        'Uploading...',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                    ],
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    )),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (imgPath == null && widget.postModel == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an image'),
                          ),
                        );
                        return;
                      }
                      try {
                        // User user = FirebaseAuth.instance.currentUser!;
                        PostModel postModel = PostModel(
                            id: '',
                            title: _titleController.text,
                            content: _contentController.text,
                            photoUrl: imgPath ?? '',
                            author: '',
                            createdAt: DateTime.now(),
                            createdByUid: "",
                            likedByUid: []);

                        if (widget.postModel != null) {
                          postModel.id = widget.postModel!.id;
                          postModel.createdAt = widget.postModel!.createdAt;
                          postModel.photoUrl = widget.postModel!.photoUrl;
                          postModel.likedByUid = widget.postModel!.likedByUid;

                          await context
                              .read<PostProvider>()
                              .updatePost(postModel, imgPath, context);
                        } else {
                          await context.read<PostProvider>().createPost(
                                postModel,
                                context,
                              );
                        }
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: Text(widget.postModel != null
                        ? 'Update Post'
                        : 'Create Post'),
                  );
          }),
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
                                    .pickImage(source: source, imageQuality: 20)
                                    .then((value) {
                                  setState(() {
                                    imgPath = value?.path;
                                  });
                                });
                              }));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      height: 25.h,
                      width: 80.w,
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
                                  height: 25.h,
                                  width: 80.w,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 28.sp,
                                  color: Colors.grey,
                                )
                          : Image.file(
                              File(imgPath!),
                              height: 25.h,
                              width: 80.w,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  TitleFieldWidget(titleController: _titleController),
                  ContentFieldWidget(contentController: _contentController),
                ].animate(interval: 80.ms).fadeIn().moveY(begin: 2.h),
              ),
            ),
          ),
        ));
  }
}
