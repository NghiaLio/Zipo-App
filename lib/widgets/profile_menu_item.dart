import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? colorScheme.onSurface, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: textColor ?? colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: theme.disabledColor, size: 20),
          ],
        ),
      ),
    );
  }
}
