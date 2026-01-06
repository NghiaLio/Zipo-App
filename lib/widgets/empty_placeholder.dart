import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyPlaceholder({
    super.key,
    this.message = 'Không có dữ liệu',
    this.icon = Icons.inbox,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getResponsiveSize(context, 64),
              color: Colors.grey[400],
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
            if (actionText != null && onAction != null) ...[
              SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
              TextButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}
