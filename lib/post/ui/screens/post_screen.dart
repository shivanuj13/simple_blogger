import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';

class PostScreen extends StatefulWidget {
  PostScreen({super.key, this.isEditable = false});
  bool? isEditable;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.isEditable!
            ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.edit),
              )
            : null,
        appBar: AppBar(
          title: const Text('Post'),
        ),
        body: Consumer<PostProvider>(builder: (context, value, wid) {
          return Column(
            children: [
              Image.network(
                  value.postList.elementAt(value.selectedIndex!).photoUrl),
              Text(value.postList.elementAt(value.selectedIndex!).title),
              Text(value.postList.elementAt(value.selectedIndex!).content),
            ],
          );
        }));
  }
}
