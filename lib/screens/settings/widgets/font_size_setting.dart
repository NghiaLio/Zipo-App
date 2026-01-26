import 'package:flutter/material.dart';

class FontSizeSetting extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double> onChanged;

  const FontSizeSetting({
    Key? key,
    required this.fontSize,
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
                color: const Color(0xFF0288D1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.text_fields,
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
                    'Cỡ chữ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${fontSize.toInt()} px',
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chọn cỡ chữ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Text(
            'Xin chào! Đây là tin nhắn mẫu',
            style: TextStyle(fontSize: _currentSize),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Icon(Icons.text_fields, size: 16),
              Expanded(
                child: Slider(
                  value: _currentSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 12,
                  activeColor: const Color(0xFF0288D1),
                  label: '${_currentSize.toInt()} px',
                  onChanged: (value) {
                    setState(() => _currentSize = value);
                  },
                ),
              ),
              const Icon(Icons.text_fields, size: 28),
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
                backgroundColor: const Color(0xFF0288D1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
