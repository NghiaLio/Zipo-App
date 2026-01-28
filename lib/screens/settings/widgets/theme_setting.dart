import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

class ThemeSetting extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onChanged;

  const ThemeSetting({
    super.key,
    required this.selectedTheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder:
              (context) => ThemeBottomSheet(
                selectedTheme: selectedTheme,
                onChanged: onChanged,
              ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.palette_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.interface_section,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getThemeLabel(context, selectedTheme),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(BuildContext context, String theme) {
    switch (theme) {
      case 'Light':
        return AppLocalizations.of(context)!.light_theme;
      case 'Dark':
        return AppLocalizations.of(context)!.dark_theme;
      case 'System':
        return AppLocalizations.of(context)!.system_theme;
      default:
        return AppLocalizations.of(context)!.light_theme;
    }
  }
}

class ThemeBottomSheet extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onChanged;

  const ThemeBottomSheet({
    super.key,
    required this.selectedTheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.select_theme_title,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.light_theme,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.light_theme_desc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            value: 'Light',
            groupValue: selectedTheme,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.dark_theme,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.dark_theme_desc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            value: 'Dark',
            groupValue: selectedTheme,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.system_theme,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.system_theme_desc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            value: 'System',
            groupValue: selectedTheme,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
