import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../../../post/ui/screens/image_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final postCount = context.watch<PostProvider>().myPostList.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, value, wid) {
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
                          height: 22.h,
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'profile',
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.sp)),
                        elevation: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.sp),
                          child: value.currentUser?.photoUrl == null ||
                                  value.currentUser!.photoUrl.isEmpty
                              ? Icon(Icons.person, size: 22.w)
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImagePage(
                                                  heroTag: value
                                                      .currentUser!.photoUrl,
                                                  imgUrl: value
                                                      .currentUser!.photoUrl,
                                                )));
                                  },
                                  child: Image.network(
                                    value.currentUser!.photoUrl,
                                    width: 22.w,
                                    height: 22.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  value.currentUser?.name ?? "User Name",
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
                SizedBox(height: 2.h),
                //todo: implement this
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          postCount.toString(),
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          postCount == 1 ? 'Post' : 'Posts',
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      children: [
                        Text(
                          value.currentUser!.subscriberCount.toString(),
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value.currentUser!.subscriberCount == 1
                              ? 'Subscriber'
                              : 'Subscribers',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, RouteConst.editProfile);
                        },
                        trailing: const Icon(Icons.edit),
                        title: const Text("Edit Profile"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, RouteConst.myPosts);
                        },
                        trailing: const Icon(Icons.post_add),
                        title: const Text("My Posts"),
                      ),
                      ListTile(
                        onTap: () async {
                          await context.read<AuthProvider>().signOut();
                          if (mounted) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                                context, RouteConst.signIn);
                          }
                        },
                        trailing: const Icon(Icons.logout),
                        title: const Text("Log Out"),
                      ),
                    ].animate(interval: 100.ms).fadeIn().moveY(begin: 2.h),
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
