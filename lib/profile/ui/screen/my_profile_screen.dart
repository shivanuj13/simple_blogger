import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Column(
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
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.sp)),
                elevation: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.sp),
                  child: FirebaseAuth.instance.currentUser?.photoURL == null
                      ? Icon(Icons.person, size: 22.w)
                      : Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!,
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
            FirebaseAuth.instance.currentUser?.displayName ?? 'Name',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  offset: const Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          // const Text('Email'),
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
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, RouteConst.signIn);
                  },
                  trailing: const Icon(Icons.logout),
                  title: const Text("Log Out"),
                ),
              ].animate(interval: 100.ms).fadeIn().moveY(begin: 2.h),
            ),
          ),

          // TextButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, RouteConst.editProfile);
          //     },
          //     child: const Text('Edit Profile')),
          // TextButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, RouteConst.myPosts);
          //     },
          //     child: const Text('My Posts')),
          // TextButton(
          //     onPressed: () async {
          //       await context.read<AuthProvider>().signOut();
          //       Navigator.popUntil(context, (route) => route.isFirst);
          //       Navigator.pushReplacementNamed(context, RouteConst.signIn);
          //     },
          //     child: const Text('Log Out'))
        ],
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
