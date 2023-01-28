import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PasswordFieldWidget extends StatefulWidget {
  const PasswordFieldWidget({super.key, required this.passwordController});
  final TextEditingController passwordController;

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        style: TextStyle(letterSpacing: 1.w),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password can\'t be empty';
          }
          return null;
        },
        controller: widget.passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_isPasswordVisible,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(_isPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility)),
          labelText: 'Password',
          border: const OutlineInputBorder(
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
