import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../widget/post_snippet_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PostProvider>().readPost();
    });
  }

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteConst.myProfile);
            },
            icon: const Icon(Icons.person),
          ),
        ],
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
        child: Consumer<PostProvider>(builder: (context, value, wid) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: ListView.builder(
                  itemCount: value.postList.length,
                  itemBuilder: (context, index) {
                    return PostSnippetWidget(
                      postModel: value.postList[index],
                      index: index,
                    );
                  },
                ),
              ),
              if (value.isLoading) const LinearProgressIndicator(),
            ],
          );
        }),
      ),
    );
  }
}


