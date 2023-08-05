import 'package:fadable_app_bar/fadable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/post/ui/screens/image_screen.dart';

import '../../../shared/const/text_style_const.dart';
import '../../../shared/route/route_const.dart';
import '../../util/post_list_type.dart';
import '../widget/delete_post_button_widget.dart';

class PostScreen extends StatefulWidget {
  final PostListType postListType;
  const PostScreen({
    super.key,
    required this.postListType,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late String uid;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    uid = context.read<AuthProvider>().currentUser!.id;
    super.initState();
  }

  @override
  void dispose() {
    if (_scrollController.hasClients) _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context, value, wid) {
      List<PostModel> postList = [];
      switch (widget.postListType) {
        case PostListType.myPost:
          postList = value.myPostList;
          break;
        case PostListType.all:
          postList = value.postList;
          break;
        case PostListType.subscription:
          postList = value.postBySubscriptions;
          break;
        case PostListType.fromAuthorProfile:
          postList = value.postBySelectedAuthor;
          break;
      }
      bool isLiked =
          postList.elementAt(value.selectedIndex!).likedByUid.contains(uid);
      return Scaffold(
          extendBodyBehindAppBar: true,
          floatingActionButton:
              postList.elementAt(value.selectedIndex!).createdByUid == uid
                  ? FloatingActionButton(
                      heroTag: 'post',
                      onPressed: () {
                        Navigator.pushNamed(context, RouteConst.postEditor,
                            arguments:
                                postList.elementAt(value.selectedIndex!));
                      },
                      child: const Icon(Icons.edit),
                    )
                  : null,
          appBar: FadableAppBar(
            scrollController: _scrollController,
            foregroundColorOnFaded: Theme.of(context).colorScheme.surface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              if (postList.elementAt(value.selectedIndex!).createdByUid == uid)
                DeletePostButtonWidget(
                  scrollController: _scrollController,
                )
            ],
          ),
          body: Stack(
            children: [
              Stack(
                children: [
                  Image.network(
                    postList.elementAt(value.selectedIndex!).photoUrl,
                    height: 34.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, obj, stack) {
                      return SizedBox(
                          width: 100.w,
                          height: 20.h,
                          child: Center(child: Icon(Icons.photo, size: 20.w)));
                    },
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    height: 34.h,
                  ),
                ],
              ),
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: 22.h,
                    ),
                    Hero(
                      tag: postList.elementAt(value.selectedIndex!).id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImagePage(
                                            imgUrl: postList
                                                .elementAt(value.selectedIndex!)
                                                .photoUrl,
                                            heroTag: postList
                                                .elementAt(value.selectedIndex!)
                                                .id,
                                          )));
                            },
                            child: Image.network(
                              postList.elementAt(value.selectedIndex!).photoUrl,
                              height: 30.h,
                              width: 80.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, obj, stack) {
                                return SizedBox(
                                    width: 100.w,
                                    height: 20.h,
                                    child: Center(
                                        child: Icon(Icons.photo, size: 20.w)));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      color: Theme.of(context).colorScheme.background,
                      child: Column(
                        children: [
                          Text(
                            DateFormat().add_yMMMEd().format(postList
                                .elementAt(value.selectedIndex!)
                                .createdAt),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            postList.elementAt(value.selectedIndex!).title,
                            style: TextStyleConst.title(context),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            postList.elementAt(value.selectedIndex!).content,
                            style: TextStyleConst.contentBlack,
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          TextButton(
                            onPressed: () {
                              if (postList
                                      .elementAt(value.selectedIndex!)
                                      .createdByUid ==
                                  uid) {
                                Navigator.pushReplacementNamed(
                                    context, RouteConst.myProfile);
                              } else {
                                value.getPostBySelectedAuthor(postList
                                    .elementAt(value.selectedIndex!)
                                    .createdByUid);
                                context.read<AuthProvider>().selectAuthor(
                                    postList
                                        .elementAt(value.selectedIndex!)
                                        .createdByUid);
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteConst.authorProfile,
                                );
                              }
                            },
                            child: Text(
                              '\u{270E}   ${postList.elementAt(value.selectedIndex!).author}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16.sp,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              value.isLikeUnlike
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                      .animate(onComplete: (controller) {
                                        controller.repeat(reverse: true);
                                      })
                                      .scale(
                                        duration: 500.milliseconds,
                                      )
                                      .shimmer(
                                        duration: 500.milliseconds,
                                      )
                                  : IconButton(
                                      onPressed: () {
                                        context
                                            .read<PostProvider>()
                                            .likeUnlikePost(
                                                context, widget.postListType);
                                      },
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                              Text(postList
                                  .elementAt(value.selectedIndex!)
                                  .likedByUid
                                  .length
                                  .toString()),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ].animate(interval: 80.ms).fadeIn().moveY(begin: 2.h),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
}
