import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/shared/const/text_style_const.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Text(
          '''Welcome ${FirebaseAuth.instance.currentUser?.displayName},

It a simple blog application where you can express your thoughts, share your experiences, and connect with others.
      
Our mission is to provide a platform that makes it easy for people to start their own blog and share their stories with the world. Whether you're a seasoned blogger or just starting out, This application has everything you need to get your ideas out there.
      
With our clean and intuitive interface, you can start writing and publishing your posts in minutes. Our platform is designed to be user-friendly, so you don't need any technical expertise to get started.
      
We believe that everyone has a story to tell, and our goal is to give you the tools you need to tell yours. So why wait? Start your blog today and join the our community.
      
Thank you for choosing us. Happy blogging !!''',
          style: TextStyleConst.contentBlack,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
