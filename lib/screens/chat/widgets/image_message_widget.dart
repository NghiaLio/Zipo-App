import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMessageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const ImageMessageWidget({super.key, required this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  color: colorScheme.onSurface.withOpacity(0.05),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  height: 220,
                  width: 180,
                  color: colorScheme.onSurface.withOpacity(0.05),
                  child: Icon(Icons.error_outline, color: colorScheme.error),
                ),
            fit: BoxFit.cover,
            width: 180,
            height: 220,
          );
        },
      ),
    );
  }
}
