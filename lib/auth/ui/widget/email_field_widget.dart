import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailFieldWidget extends StatefulWidget {
  const EmailFieldWidget({super.key, required this.emailController});
  final TextEditingController emailController;

  @override
  State<EmailFieldWidget> createState() => _EmailFieldWidgetState();
}

class _EmailFieldWidgetState extends State<EmailFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email can\'t be empty';
          } else {
            if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                .hasMatch(value)) {
              return 'Please enter a valid email';
            }
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        controller: widget.emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Email',
          border: OutlineInputBorder(
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
