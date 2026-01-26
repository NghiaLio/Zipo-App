import 'package:flutter/material.dart';

class ThemeSetting extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onChanged;

  const ThemeSetting({
    Key? key,
    required this.selectedTheme,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
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
                color: const Color(0xFF0288D1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.palette_outlined,
                color: Color(0xFF0288D1),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giao diện',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getThemeLabel(selectedTheme),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(String theme) {
    switch (theme) {
      case 'light':
        return 'Sáng';
      case 'dark':
        return 'Tối';
      case 'auto':
        return 'Tự động';
      default:
        return 'Sáng';
    }
  }
}

class ThemeBottomSheet extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onChanged;

  const ThemeBottomSheet({
    Key? key,
    required this.selectedTheme,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chọn giao diện',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('Sáng'),
            subtitle: const Text('Giao diện sáng'),
            value: 'light',
            groupValue: selectedTheme,
            activeColor: const Color(0xFF0288D1),
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Tối'),
            subtitle: const Text('Giao diện tối'),
            value: 'dark',
            groupValue: selectedTheme,
            activeColor: const Color(0xFF0288D1),
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Tự động'),
            subtitle: const Text('Theo cài đặt hệ thống'),
            value: 'auto',
            groupValue: selectedTheme,
            activeColor: const Color(0xFF0288D1),
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
