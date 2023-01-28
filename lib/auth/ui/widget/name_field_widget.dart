import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NameFieldWidget extends StatefulWidget {
  const NameFieldWidget({super.key, required this.nameController});
  final TextEditingController nameController;

  @override
  State<NameFieldWidget> createState() => _NameFieldWidgetState();
}

class _NameFieldWidgetState extends State<NameFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name can\'t be empty';
          }
          return null;
        },
        controller: widget.nameController,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Name',
          border: OutlineInputBorder(
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
