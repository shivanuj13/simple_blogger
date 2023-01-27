import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/post/provider/post_provider.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PostProvider>().readPost());
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Consumer<PostProvider>(builder: (context, value, wid) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      if (!value.isLoading && value.postList.isEmpty)
                        const Center(
                          child: Text('No Post'),
                        ),
                      for (int i = 0; i < value.postList.length; i++)
                        ListTile(
                          onTap: () {
                            context.read<PostProvider>().selectPost(i);
                            Navigator.pushNamed(context, RouteConst.post,
                                arguments: false);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              value.postList.elementAt(i).photoUrl,
                            ),
                          ),
                          title: Text(value.postList.elementAt(i).title),
                          subtitle: Text(value.postList.elementAt(i).content),
                          trailing: Text(DateFormat()
                              .add_yMMMMd()
                              .format(value.postList.elementAt(i).createdAt)),
                        ),
                    ],
                  ),
                  if (value.isLoading) const LinearProgressIndicator(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
