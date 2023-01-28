import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TitleFieldWidget extends StatelessWidget {
  const TitleFieldWidget({super.key, required this.titleController});
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Title can\'t be empty';
          }
          return null;
        },
        controller: titleController,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
