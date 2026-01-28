import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/themes/app_colors.dart';

class StorageManagementScreen extends StatelessWidget {
  const StorageManagementScreen({super.key});

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
          AppLocalizations.of(context)!.storage_management_menu,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.storage,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.cache_memory,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.optimize_performance,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.cache_description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showClearCacheDialog(context);
                      },
                      icon: const Icon(Icons.cleaning_services, size: 20),
                      label: Text(
                        AppLocalizations.of(context)!.clear_cache_button,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.notice_label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    Icons.info_outline,
                    AppLocalizations.of(context)!.downloaded_media_notice,
                    context,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoItem(
                    Icons.refresh,
                    AppLocalizations.of(context)!.cache_recreation_notice,
                    context,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoItem(
                    Icons.speed,
                    AppLocalizations.of(context)!.speed_notice,
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppLocalizations.of(context)!.clear_cache_confirm_title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              AppLocalizations.of(context)!.clear_cache_confirm_message,
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackBar(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.accept_button),
              ),
            ],
          ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.clear_cache_success,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
