import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_blog/post/model/post_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/post/ui/widget/post_snippet_widget.dart';
import '../../provider/post_provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<PostModel> searchList = [];
  List<int> indexList = [];

  void _onDismiss() {
    query = '';
    searchList = [];
    indexList = [];
  }

  void _onSearch(String query, BuildContext context) {
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
    }
    this.searchList = searchList;
    this.indexList = indexList;
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

    return ListView.builder(
      itemBuilder: (context, index) {
        return PostSnippetWidget(
          postModel: searchList[index],
          index: indexList[index],
        );
      },
      itemCount: searchList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onSearch(query, context);

    return ListView.builder(
      itemBuilder: (context, index) {
        return PostSnippetWidget(
          postModel: searchList[index],
          index: indexList[index],
        );
      },
      itemCount: searchList.length,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: const  InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 18.sp);
}
