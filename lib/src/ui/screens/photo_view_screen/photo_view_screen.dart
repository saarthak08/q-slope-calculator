import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

class PhotoViewScreen extends StatelessWidget {
  static const route = "/photo-view";
  final ImageProvider imageProvider;
  const PhotoViewScreen({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    final vpH = getViewPortHeight(context);
    final vpW = getViewPortWidth(context);
    return Stack(children: [
      PhotoView(
        enableRotation: true,
        strictScale: true,
        loadingBuilder: (context, event) => Container(
            alignment: Alignment.center,
            height: vpH * 0.025,
            width: vpW * 0.025,
            child: const CircularProgressIndicator()),
        imageProvider: imageProvider,
      ),
      Positioned(
          left: getViewPortWidth(context) * 0.005,
          top: getViewPortHeight(context) * 0.01,
          child: const BackButton()),
    ]);
  }
}
