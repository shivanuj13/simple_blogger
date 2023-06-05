import 'package:fadable_app_bar/fadable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:simple_blog/post/provider/post_provider.dart';

import '../../../shared/const/text_style_const.dart';
import '../../../shared/route/route_const.dart';

class PostScreen extends StatefulWidget {
  final bool isMyPost;
  const PostScreen({
    super.key,
    required this.isMyPost,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  late String uid;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  late final AnimationController _animationController;

  @override
  void initState() {
    uid = context.read<AuthProvider>().currentUser!.id;
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.position.pixels;
        if (_scrollPosition > 15.h) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        // _animationController.forward();
      });
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
      bool isLiked = value.postList
          .elementAt(value.selectedIndex!)
          .likedByUid
          .contains(uid);
      List<PostModel> postList =
          widget.isMyPost ? value.myPostList : value.postList;
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
                IconButton(
                  onPressed: context.watch<PostProvider>().isDeleting
                      ? null
                      : () async {
                          try {
                            await context.read<PostProvider>().deletePost(
                                  postList.elementAt(value.selectedIndex!).id,
                                  postList
                                      .elementAt(value.selectedIndex!)
                                      .photoUrl,
                                  context,
                                );
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
                  icon: context.watch<PostProvider>().isDeleting
                      ? SizedBox(
                          height: 4.h,
                          width: 4.h,
                          child: CircularProgressIndicator(
                            color: _scrollPosition < 15.h ? Colors.white : null,
                          ),
                        )
                      : const Icon(Icons.delete),
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
                          Text(
                            '\u{270E}   ${value.postList.elementAt(value.selectedIndex!).author}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<PostProvider>()
                                      .likeUnlikePost(context);
                                },
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: Theme.of(context).colorScheme.primary,
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
