import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class LoadingPlaceholder extends StatelessWidget {
  final String? message;

  const LoadingPlaceholder({super.key, this.message = 'Đang tải...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          Text(
            message!,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 16),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
