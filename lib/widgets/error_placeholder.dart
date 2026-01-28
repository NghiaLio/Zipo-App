import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import '../utils/responsive_helper.dart';

class ErrorPlaceholder extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorPlaceholder({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveHelper.getResponsiveSize(context, 64),
            color: colorScheme.error.withOpacity(0.7),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          Text(
            message ?? AppLocalizations.of(context)!.error_occurred_message,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 16),
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text(AppLocalizations.of(context)!.retry_button),
            ),
          ],
        ],
      ),
    );
  }
}
