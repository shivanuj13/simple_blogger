import 'package:flutter/material.dart';
import 'package:simple_blog/shared/route/route_const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < 20; i++)
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, RouteConst.post);
                },
                leading: Icon(Icons.post_add),
                title: Text('Post $i'),
                subtitle: Text('Post $i'),
              ),
          ],
        ),
      ),
    );
  }
}
