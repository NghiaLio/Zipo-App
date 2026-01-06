import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMessageWidget extends StatelessWidget {
  final String imageUrl;

  const ImageMessageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder:
              (context, url) => Container(
                height: 220,
                width: 180,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          width: 180,
          height: 220,
        );
      },
    );
  }
}
