import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/auth/provider/auth_provider.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/post/ui/widget/post_snippet_widget.dart';
import 'package:simple_blog/post/util/post_list_type.dart';
import '../../../auth/model/user_model.dart';
import '../../../shared/route/route_const.dart';
import '../../provider/post_provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<PostModel> searchList = [];
  List<int> indexList = [];
  List<UserModel> authorList = [];

  void _onDismiss() {
    query = '';
    searchList = [];
    indexList = [];
    authorList = [];
  }

  void _onSearch(String query, BuildContext context) {
    List<UserModel> authorList = context.read<AuthProvider>().userList;
    List<UserModel> searchAuthorList = [];
    List<PostModel> postList = context.read<PostProvider>().postList;
    List<PostModel> searchList = [];
    List<int> indexList = [];
    if (query.isNotEmpty) {
      for (int i = 0; i < postList.length; i++) {
        if (postList[i].title.toLowerCase().contains(query.toLowerCase())) {
          searchList.add(postList[i]);
          indexList.add(i);
        }
      }
      for (int i = 0; i < authorList.length; i++) {
        if (authorList[i].name.toLowerCase().contains(query.toLowerCase())) {
          searchAuthorList.add(authorList[i]);
        }
      }
    }
    this.searchList = searchList;
    this.indexList = indexList;
    this.authorList = searchAuthorList;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _onDismiss();
          // showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        _onDismiss();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _onSearch(query, context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                text: 'Posts',
              ),
              Tab(
                text: 'Authors',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  return PostSnippetWidget(
                    postModel: searchList[index],
                    index: indexList[index],
                    postListType: PostListType.all,
                  );
                },
                itemCount: searchList.length,
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(authorList[index].photoUrl),
                    ),
                    title: Text(authorList[index].name),
                    onTap: () {
                      // close(context, authorList[index]);
                      if (authorList[index].id ==
                          context.read<AuthProvider>().currentUser!.id) {
                        Navigator.pushNamed(context, RouteConst.myProfile);
                        return;
                      }
                      context
                          .read<PostProvider>()
                          .getPostBySelectedAuthor(authorList[index].id);
                      context
                          .read<AuthProvider>()
                          .selectAuthor(authorList.elementAt(index).id);
                      Navigator.pushNamed(context, RouteConst.authorProfile,
                          arguments: authorList[index]);
                    },
                  );
                },
                itemCount: authorList.length,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onSearch(query, context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                text: 'Posts',
              ),
              Tab(
                text: 'Authors',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  return PostSnippetWidget(
                    postModel: searchList[index],
                    index: indexList[index],
                    postListType: PostListType.all,
                  );
                },
                itemCount: searchList.length,
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(authorList[index].photoUrl),
                    ),
                    title: Text(authorList[index].name),
                    onTap: () {
                      // close(context, authorList[index]);
                      if (authorList[index].id ==
                          context.read<AuthProvider>().currentUser!.id) {
                        Navigator.pushNamed(context, RouteConst.myProfile);
                        return;
                      }
                      context
                          .read<PostProvider>()
                          .getPostBySelectedAuthor(authorList[index].id);
                      context
                          .read<AuthProvider>()
                          .selectAuthor(authorList.elementAt(index).id);
                      Navigator.pushNamed(context, RouteConst.authorProfile,
                          arguments: authorList[index]);
                    },
                  );
                },
                itemCount: authorList.length,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 18.sp);
}
