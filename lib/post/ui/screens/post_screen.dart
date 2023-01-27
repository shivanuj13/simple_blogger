import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:simple_blog/post/provider/post_provider.dart';

import '../../../shared/route/route_const.dart';

class PostScreen extends StatefulWidget {
  bool isMyPost;
  PostScreen({
    super.key,
    required this.isMyPost,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context, value, wid) {
      List<PostModel> postList =
          widget.isMyPost ? value.myPostList : value.postList;
      return Scaffold(
          floatingActionButton:
              postList.elementAt(value.selectedIndex!).createdByUid == uid
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteConst.postEditor,
                            arguments:
                                postList.elementAt(value.selectedIndex!));
                      },
                      child: const Icon(Icons.edit),
                    )
                  : null,
          appBar: AppBar(
            title: const Text('Post'),
            actions: [
              if (postList.elementAt(value.selectedIndex!).createdByUid == uid)
                TextButton(
                  onPressed: () {
                    context.read<PostProvider>().deletePost(
                        postList.elementAt(value.selectedIndex!).uid,
                        postList.elementAt(value.selectedIndex!).photoUrl);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                )
            ],
          ),
          body: Column(
            children: [
              Image.network(postList.elementAt(value.selectedIndex!).photoUrl),
              Text(postList.elementAt(value.selectedIndex!).title),
              Text(postList.elementAt(value.selectedIndex!).content),
            ],
          ));
    });
  }
}
