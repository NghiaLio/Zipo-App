import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import '../utils/responsive_helper.dart';

class LoadingPlaceholder extends StatelessWidget {
  final String? message;

  const LoadingPlaceholder({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary, strokeWidth: 2),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          Text(
            message ?? AppLocalizations.of(context)!.loading_label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, 16),
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
