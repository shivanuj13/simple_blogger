import 'package:flutter/material.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteConst.postEditor);
        },
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < 20; i++)
              ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteConst.post,
                  );
                },
                leading: Icon(Icons.post_add),
                title: Text('Post $i'),
                subtitle: Text('Post $i'),
              ),
          ],
        ),
      ),
    );
  }
}
