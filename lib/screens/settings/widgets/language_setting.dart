import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
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
                color: const Color(0xFF0288D1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.language,
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
                    'Ngôn ngữ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedLanguage == 'vi' ? 'Tiếng Việt' : 'English',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chọn ngôn ngữ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('Tiếng Việt'),
            value: 'vi',
            groupValue: selectedLanguage,
            activeColor: const Color(0xFF0288D1),
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: selectedLanguage,
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
