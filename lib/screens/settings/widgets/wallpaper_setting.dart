import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

class WallpaperSetting extends StatelessWidget {
  final String selectedWallpaper;
  final ValueChanged<String> onChanged;

  const WallpaperSetting({
    super.key,
    required this.selectedWallpaper,
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
              (context) => WallpaperBottomSheet(
                selectedWallpaper: selectedWallpaper,
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
                Icons.wallpaper_outlined,
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
                    AppLocalizations.of(context)!.chat_wallpaper_menu,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getWallpaperLabel(context, selectedWallpaper),
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

  String _getWallpaperLabel(BuildContext context, String wallpaper) {
    final l10n = AppLocalizations.of(context)!;
    switch (wallpaper) {
      case '0xFF29B6F6':
        return l10n.default_wallpaper;
      case '0xFF4CAF50':
        return l10n.green_wallpaper;
      case 'gradient':
        return l10n.pink_wallpaper;
      case '0xFF9C27B0':
        return l10n.pink_wallpaper;
      case '0xFFFF9800':
        return l10n.orange_wallpaper;
      default:
        return l10n.default_wallpaper;
    }
  }
}

class WallpaperBottomSheet extends StatelessWidget {
  final String selectedWallpaper;
  final ValueChanged<String> onChanged;

  const WallpaperBottomSheet({
    super.key,
    required this.selectedWallpaper,
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
            AppLocalizations.of(context)!.select_wallpaper_title,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.default_wallpaper,
              style: theme.textTheme.bodyLarge,
            ),
            value: '0xFF29B6F6',
            groupValue: selectedWallpaper,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.green_wallpaper,
              style: theme.textTheme.bodyLarge,
            ),
            value: '0xFF4CAF50',
            groupValue: selectedWallpaper,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.pink_wallpaper,
              style: theme.textTheme.bodyLarge,
            ),
            value: '0xFF9C27B0',
            groupValue: selectedWallpaper,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(
              AppLocalizations.of(context)!.orange_wallpaper,
              style: theme.textTheme.bodyLarge,
            ),
            value: '0xFFFF9800',
            groupValue: selectedWallpaper,
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
