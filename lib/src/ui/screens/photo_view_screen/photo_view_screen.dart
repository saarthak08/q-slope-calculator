import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  static const route = "/photo-view";
  final ImageProvider imageProvider;
  const PhotoViewScreen({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(120),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PhotoView(
        enableRotation: true,
        loadingBuilder:
            (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, size: 56, color: Colors.white54),
                  SizedBox(height: 12),
                  Text(
                    'Unable to display image',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
        imageProvider: imageProvider,
      ),
    );
  }
}
