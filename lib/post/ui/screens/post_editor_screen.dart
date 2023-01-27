import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:simple_blog/post/provider/post_provider.dart';

class PostEditorScreen extends StatefulWidget {
  const PostEditorScreen({super.key});

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  String? imgPath;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Editor'),
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () async {
                await ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((value) {
                  setState(() {
                    imgPath = value!.path;
                  });
                });
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: imgPath == null
                    ? Icon(Icons.add)
                    : Image.file(File(imgPath!)),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: 'Content',
              ),
            ),
            Consumer<PostProvider>(builder: (context, value, wid) {
              return ElevatedButton(
                onPressed: () async {
                  User user = FirebaseAuth.instance.currentUser!;
                  PostModel postModel = PostModel(
                    uid: '',
                    title: titleController.text,
                    content: contentController.text,
                    photoUrl: imgPath!,
                    createdAt: DateTime.now(),
                    createdByUid: user.uid,
                  );
                  await value.createPost(
                    postModel,
                  );
                  Navigator.pop(context);
                },
                child: value.isUpLoading
                    ? const RefreshProgressIndicator()
                    : const Text('Save'),
              );
            }),
          ],
        ));
  }
}
