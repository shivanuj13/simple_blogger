import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../../provider/post_provider.dart';

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
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PostProvider>().readPost();
        },
        child: SingleChildScrollView(
          child: Consumer<PostProvider>(builder: (context, value, wid) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      if (!value.isLoading && value.myPostList.isEmpty)
                        const Center(
                          child: Text('No Post'),
                        ),
                      for (int i = 0; i < value.myPostList.length; i++)
                        ListTile(
                          onTap: () {
                            context.read<PostProvider>().selectPost(i);
                            Navigator.pushNamed(context, RouteConst.post,
                                arguments: true);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              value.myPostList.elementAt(i).photoUrl,
                            ),
                          ),
                          title: Text(value.myPostList.elementAt(i).title),
                          subtitle: Text(value.myPostList.elementAt(i).content),
                        ),
                    ],
                  ),
                  if (value.isLoading) const LinearProgressIndicator(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
