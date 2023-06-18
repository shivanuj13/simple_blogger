import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../../provider/post_provider.dart';
import '../../util/post_list_type.dart';
import '../widget/post_snippet_widget.dart';

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
        heroTag: 'post',
        onPressed: () {
          Navigator.pushNamed(context, RouteConst.postEditor);
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PostProvider>().readPost(context);
        },
        child: Consumer<PostProvider>(builder: (context, value, wid) {
          return value.myPostList.isEmpty
              ? SingleChildScrollView(
                  child: SizedBox(
                    height: 80.h,
                    child: Center(
                      child: Text(
                        'You have not posted anything yet',
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    ListView.builder(
                        itemCount: value.myPostList.length,
                        itemBuilder: (context, index) {
                          return PostSnippetWidget(
                            index: index,
                            postModel: value.myPostList[index],
                            postListType: PostListType.myPost,
                          );
                        }),
                    if (value.isLoading) const LinearProgressIndicator(),
                  ].animate(interval: 100.ms).fadeIn().moveY(begin: 4.h),
                );
        }),
      ),
    );
  }
}
