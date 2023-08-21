import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContentFieldWidget extends StatelessWidget {
  const ContentFieldWidget({super.key, required this.contentController});
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Content can\'t be empty';
          }
          return null;
        },
        controller: contentController,
        keyboardType: TextInputType.multiline,
        minLines: 10,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Content',
          border: OutlineInputBorder(
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
