



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../provider/post_provider.dart';

class DeletePostButtonWidget extends StatefulWidget {
  const DeletePostButtonWidget({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  State<DeletePostButtonWidget> createState() => _DeletePostButtonWidgetState();
}

class _DeletePostButtonWidgetState extends State<DeletePostButtonWidget> {
  bool _isFaded = true;
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels > 15.h && _isFaded) {
        setState(() {
          _isFaded = false;
        });
      } else {
        if (widget.scrollController.position.pixels < 15.h && !_isFaded) {
        setState(() {
          _isFaded = true;
        });
      }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context, value, wid) {
      return IconButton(
        onPressed: value.isDeleting
            ? null
            : () async {
                try {
                  await value.deletePost(
                    value.postList.elementAt(value.selectedIndex!).id,
                    context,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
        icon: value.isDeleting
            ? SizedBox(
                height: 4.h,
                width: 4.h,
                child: CircularProgressIndicator(
                  color: _isFaded ? Colors.white : null,
                ),
              )
            : const Icon(Icons.delete),
      );
    });
  }
}