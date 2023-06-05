import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/const/text_style_const.dart';
import '../../../shared/route/route_const.dart';
import '../../model/post_model.dart';
import '../../provider/post_provider.dart';

class PostSnippetWidget extends StatefulWidget {
  const PostSnippetWidget(
      {super.key,
      required this.postModel,
      required this.index,
      this.isMyPost = false});
  final PostModel postModel;
  final int index;
  final bool isMyPost;

  @override
  State<PostSnippetWidget> createState() => _PostSnippetWidgetState();
}

class _PostSnippetWidgetState extends State<PostSnippetWidget> {
  void selectPost(int index) {
    context.read<PostProvider>().selectPost(index);
    Navigator.pushNamed(context, RouteConst.post, arguments: widget.isMyPost);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: InkWell(
        onTap: () {
          selectPost(widget.index);
        },
        child: Card(
          borderOnForeground: false,
          color: Theme.of(context).colorScheme.background,
          elevation: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(2.w)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Hero(
                        tag: widget.postModel.id,
                        child: Image.network(
                          widget.postModel.photoUrl,
                          height: 20.h,
                          width: 100.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5.h, horizontal: 1.w),
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.8),
                        child: Text(DateFormat()
                            .add_yMMMd()
                            .format(widget.postModel.createdAt)),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleConst.title(context),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 0.8,
                    ),
                    Text(
                      widget.postModel.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleConst.contentBlack,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 50.milliseconds)
        .moveY(delay: 50.milliseconds, begin: 4.h);
  }
}
