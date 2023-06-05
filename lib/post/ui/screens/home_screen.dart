import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../widget/custom_search_delegate.dart';
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
      context.read<PostProvider>().readPost(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Builder(builder: (context) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('My Profile'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.pushNamed(context, RouteConst.myProfile);
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.help_outline),
                //   title: const Text('Help'),
                //   onTap: () {
                //     Scaffold.of(context).closeDrawer();
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.pushNamed(context, RouteConst.about);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await context.read<AuthProvider>().signOut();
                    if (mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                    if (mounted) {
                      Navigator.pushReplacementNamed(
                          context, RouteConst.signIn);
                    }
                  },
                  trailing: context.watch<AuthProvider>().isLoading
                      ? const CircularProgressIndicator()
                      : null,
                ),
              ],
            );
          }),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          Hero(
            tag: 'profile',
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteConst.myProfile);
              },
              icon: const Icon(Icons.person),
            ),
          ),
        ],
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
