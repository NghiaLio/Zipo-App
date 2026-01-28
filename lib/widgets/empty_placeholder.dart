import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import '../utils/responsive_helper.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyPlaceholder({
    super.key,
    this.message,
    this.icon = Icons.inbox,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              color: theme.disabledColor,
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
            Text(
              message ?? AppLocalizations.of(context)!.no_data_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 16),
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionText!,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
