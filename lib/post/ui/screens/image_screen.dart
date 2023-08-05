import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, required this.heroTag, required this.imgUrl});
  final String? heroTag;
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PhotoView(
          minScale: 0.25,
          maxScale: 4.0,
          heroAttributes: heroTag==null?null: PhotoViewHeroAttributes(tag: heroTag!),
          imageProvider: NetworkImage(imgUrl)),
    );
  }
}
