import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

class FontSizeSetting extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double> onChanged;

  const FontSizeSetting({
    super.key,
    required this.fontSize,
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
          isScrollControlled: true,
          builder:
              (context) =>
                  FontSizeBottomSheet(fontSize: fontSize, onChanged: onChanged),
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
                Icons.text_fields,
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
                    AppLocalizations.of(context)!.font_size_menu,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${fontSize.toInt()} px',
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

class FontSizeBottomSheet extends StatefulWidget {
  final double fontSize;
  final ValueChanged<double> onChanged;

  const FontSizeBottomSheet({
    Key? key,
    required this.fontSize,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<FontSizeBottomSheet> createState() => _FontSizeBottomSheetState();
}

class _FontSizeBottomSheetState extends State<FontSizeBottomSheet> {
  late double _currentSize;

  @override
  void initState() {
    super.initState();
    _currentSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.select_font_size_title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 30),
          Text(
            l10n.sample_message,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: _currentSize),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Icon(Icons.text_fields, size: 16, color: colorScheme.onSurface),
              Expanded(
                child: Slider(
                  value: _currentSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 12,
                  activeColor: colorScheme.primary,
                  label: '${_currentSize.toInt()} px',
                  onChanged: (value) {
                    setState(() => _currentSize = value);
                  },
                ),
              ),
              Icon(Icons.text_fields, size: 28, color: colorScheme.onSurface),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onChanged(_currentSize);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l10n.accept_button,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
