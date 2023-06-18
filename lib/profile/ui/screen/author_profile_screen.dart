import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';

import '../../../post/ui/widget/post_snippet_widget.dart';
import '../../../post/util/post_list_type.dart';

class AuthorProfileScreen extends StatefulWidget {
  const AuthorProfileScreen({super.key});

  @override
  State<AuthorProfileScreen> createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer2<PostProvider, AuthProvider>(
        builder: (context, postProvider, authProvider, wid) {
          final isSubscribed = authProvider.currentUser?.subscriptionList
                  .contains(authProvider.selectedAuthor?.id) ??
              false;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.h, top: 2.h),
                      child: ClipPath(
                        clipper: SkewCut(),
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          width: double.infinity,
                          height: 16.h,
                        ),
                      ),
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.sp)),
                      elevation: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.sp),
                        child: authProvider.selectedAuthor?.photoUrl == null ||
                                authProvider.selectedAuthor!.photoUrl.isEmpty
                            ? Icon(Icons.person, size: 22.w)
                            : Image.network(
                                authProvider.selectedAuthor!.photoUrl,
                                width: 22.w,
                                height: 22.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  authProvider.selectedAuthor?.name ?? "User Name",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                //todo: implement this
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          postProvider.postBySelectedAuthor.length.toString(),
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          postProvider.postBySelectedAuthor.length == 1
                              ? 'Post'
                              : 'Posts',
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      children: [
                        Text(
                          authProvider.selectedAuthor?.subscriberCount
                                  .toString() ??
                              '0',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          authProvider.selectedAuthor?.subscriberCount == 1
                              ? 'Subscriber'
                              : 'Subscribers',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                FilledButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(80.w),
                      backgroundColor: isSubscribed
                          ? const Color.fromARGB(255, 255, 219, 219)
                          : Theme.of(context).colorScheme.primary,
                      foregroundColor: isSubscribed
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                    ),
                    onPressed: () async {
                      await authProvider.updateSubscription(
                        authProvider.selectedAuthor!.id,
                      );
                      await authProvider.getAllUsers();
                      postProvider.getAllPostsFromSubscription(
                          authProvider.currentUser!.subscriptionList);
                      authProvider
                          .selectAuthor(authProvider.selectedAuthor!.id);
                    },
                    child: authProvider.isUpdatingSubscription
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isSubscribed ? 'Subscribed' : 'Subscribe',
                          )),
                SizedBox(height: 2.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      SizedBox(height: 2.h),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: postProvider.postBySelectedAuthor.length,
                          itemBuilder: (context, index) {
                            return PostSnippetWidget(
                              index: index,
                              postModel:
                                  postProvider.postBySelectedAuthor[index],
                              postListType: PostListType.fromAuthorProfile,
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SkewCut extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addPolygon([
        Offset(0, size.height / 3),
        Offset(size.width, 0),
        Offset(size.width, size.height - size.height / 3),
        Offset(0, size.height),
      ], true);

    return path;
  }

  @override
  bool shouldReclip(SkewCut oldClipper) => true;
}
