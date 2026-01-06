import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ErrorPlaceholder extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorPlaceholder({
    super.key,
    this.message = 'Đã xảy ra lỗi',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveHelper.getResponsiveSize(context, 64),
            color: Colors.red[300],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          Text(
            message!,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 16),
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
            ElevatedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ],
      ),
    );
  }
}
