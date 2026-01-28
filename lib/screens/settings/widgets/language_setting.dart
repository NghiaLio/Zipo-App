import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

class LanguageSetting extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  const LanguageSetting({
    Key? key,
    required this.selectedLanguage,
    required this.onChanged,
  }) : super(key: key);

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
              (context) => LanguageBottomSheet(
                selectedLanguage: selectedLanguage,
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
              child: Icon(Icons.language, color: colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language_menu,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedLanguage == 'vi'
                        ? AppLocalizations.of(context)!.vietnamese_label
                        : AppLocalizations.of(context)!.english_label,
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
}

class LanguageBottomSheet extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  const LanguageBottomSheet({
    Key? key,
    required this.selectedLanguage,
    required this.onChanged,
  }) : super(key: key);

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
            AppLocalizations.of(context)!.select_language_title,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.vietnamese_label,
              style: theme.textTheme.bodyLarge,
            ),
            value: 'vi',
            groupValue: selectedLanguage,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.english_label,
              style: theme.textTheme.bodyLarge,
            ),
            value: 'en',
            groupValue: selectedLanguage,
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
