import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({super.key, required this.onImageSelected});
  final Function(ImageSource) onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              iconSize: 24.sp,
              onPressed: () async {
                onImageSelected(ImageSource.camera);
                Navigator.pop(context);
              },
              icon: Column(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.camera_alt),
                Text('Camera'),
              ])),
          IconButton(
              iconSize: 24.sp,
              onPressed: () async {
                onImageSelected(ImageSource.gallery);
                Navigator.pop(context);
              },
              icon: Column(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.image),
                Text('Gallery'),
              ])),
        ],
      ),
    );
  }
}
