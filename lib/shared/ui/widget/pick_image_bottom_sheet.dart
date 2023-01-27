import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PickImageBottomSheet {
  PickImageBottomSheet._();
  static final PickImageBottomSheet instance = PickImageBottomSheet._();

  void show(BuildContext context, Function(ImageSource) onImageSelected) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 30.sp,
                    onPressed: () async {
                      onImageSelected(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    icon:
                        Column(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.camera_alt),
                      Text('Camera'),
                    ])),
                IconButton(
                    iconSize: 30.sp,
                    onPressed: () async {
                      onImageSelected(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    icon:
                        Column(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.image),
                      Text('Gallery'),
                    ])),
              ],
            ),
          );
        });
  }
}
