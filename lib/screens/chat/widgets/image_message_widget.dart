import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMessageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const ImageMessageWidget({super.key, required this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
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
      ),
    );
  }
}
