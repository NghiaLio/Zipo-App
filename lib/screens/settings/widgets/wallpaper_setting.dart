import 'package:flutter/material.dart';

class WallpaperSetting extends StatelessWidget {
  final String selectedWallpaper;
  final ValueChanged<String> onChanged;

  const WallpaperSetting({
    Key? key,
    required this.selectedWallpaper,
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
                color: const Color(0xFF0288D1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.wallpaper_outlined,
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
                    'Hình nền chat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getWallpaperLabel(selectedWallpaper),
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

  String _getWallpaperLabel(String wallpaper) {
    switch (wallpaper) {
      case 'default':
        return 'Mặc định';
      case 'blue':
        return 'Xanh dương';
      case 'gradient':
        return 'Gradient';
      case 'custom':
        return 'Tùy chỉnh';
      default:
        return 'Mặc định';
    }
  }
}

class WallpaperBottomSheet extends StatelessWidget {
  final String selectedWallpaper;
  final ValueChanged<String> onChanged;

  const WallpaperBottomSheet({
    Key? key,
    required this.selectedWallpaper,
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
            'Chọn hình nền',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('Mặc định'),
            value: 'default',
            groupValue: selectedWallpaper,
            activeColor: const Color(0xFF0288D1),
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Xanh dương'),
            value: 'blue',
            groupValue: selectedWallpaper,
            activeColor: const Color(0xFF0288D1),
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Gradient'),
            value: 'gradient',
            groupValue: selectedWallpaper,
            activeColor: const Color(0xFF0288D1),
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Tùy chỉnh'),
            value: 'custom',
            groupValue: selectedWallpaper,
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
