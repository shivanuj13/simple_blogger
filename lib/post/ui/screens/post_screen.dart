import 'package:flutter/material.dart';

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
        body: const Center(
          child: Text('Post Screen'),
        ));
  }
}
