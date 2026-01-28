import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import '../../utils/responsive_helper.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.about_title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/Brand Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: colorScheme.onPrimary,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Zipo Social',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 24),
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.version_label('1.0.0'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // About App Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.about_app_section,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.about_app_description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Features Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.main_features_section,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.message,
                    AppLocalizations.of(context)!.realtime_messaging_title,
                    AppLocalizations.of(context)!.realtime_messaging_desc,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.image,
                    AppLocalizations.of(context)!.media_sharing_title,
                    AppLocalizations.of(context)!.media_sharing_desc,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.people,
                    AppLocalizations.of(context)!.friend_management_title,
                    AppLocalizations.of(context)!.friend_management_desc,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.notifications,
                    AppLocalizations.of(context)!.smart_notifications_title,
                    AppLocalizations.of(context)!.smart_notifications_desc,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.security,
                    AppLocalizations.of(context)!.high_security_title,
                    AppLocalizations.of(context)!.high_security_desc,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Company Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.about_us_section,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.about_us_description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.contact_us_label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.contact_info,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Copyright
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.copyright_text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, 12),
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 12),
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
