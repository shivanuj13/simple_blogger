import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/post/util/post_list_type.dart';
import 'package:simple_blog/shared/route/route_const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/custom_search_delegate.dart';
import '../widget/post_snippet_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String version = '';
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        setState(() {
          version = packageInfo.version;
        });
      });
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
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).closeDrawer();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ListTile(
                    trailing: const Icon(Icons.person),
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
                    trailing: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.pushNamed(context, RouteConst.about);
                    },
                  ),
                  ListTile(
                    trailing: const Icon(Icons.logout),
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
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                              "https://github.com/shivanuj13/simple_blogger"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text('Version: $version')),
                  SizedBox(
                    height: 2.h,
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
        body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'My Subscription'),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await context.read<PostProvider>().readPost(context);
                      },
                      child: Consumer<PostProvider>(
                          builder: (context, value, wid) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: value.postList.isEmpty
                                  ? SingleChildScrollView(
                                      child: SizedBox(
                                        height: 80.h,
                                        child: Center(
                                          child: Text(
                                            'No post available',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: value.postList.length,
                                      itemBuilder: (context, index) {
                                        return PostSnippetWidget(
                                          postModel: value.postList[index],
                                          index: index,
                                          postListType: PostListType.all,
                                        );
                                      },
                                    ),
                            ),
                            if (value.isLoading)
                              const LinearProgressIndicator(),
                          ],
                        );
                      }),
                    ),

                    // Subscription
                    RefreshIndicator(
                      onRefresh: () async {
                        await context.read<PostProvider>().readPost(context);
                      },
                      child: Consumer<PostProvider>(
                          builder: (context, value, wid) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: value.postBySubscriptions.isEmpty
                                  ? SingleChildScrollView(
                                      child: SizedBox(
                                        height: 80.h,
                                        child: Center(
                                          child: Text(
                                            'No post from your subscription',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          value.postBySubscriptions.length,
                                      itemBuilder: (context, index) {
                                        return PostSnippetWidget(
                                          postModel:
                                              value.postBySubscriptions[index],
                                          index: index,
                                          postListType:
                                              PostListType.subscription,
                                        );
                                      },
                                    ),
                            ),
                            if (value.isLoading)
                              const LinearProgressIndicator(),
                          ],
                        );
                      }),
                    ),
                  ]),
                ),
              ],
            )));
  }
}
