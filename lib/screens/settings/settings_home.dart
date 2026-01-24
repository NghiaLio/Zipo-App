import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'vi';
  String selectedTheme = 'light';
  double fontSize = 16.0;
  bool autoDownloadImages = true;
  bool autoDownloadVideos = false;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool showOnlineStatus = true;
  bool readReceipts = true;
  String chatWallpaper = 'default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Giao diện
            _buildSectionTitle('Giao diện'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  LanguageSetting(
                    selectedLanguage: selectedLanguage,
                    onChanged: (value) {
                      setState(() => selectedLanguage = value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  ThemeSetting(
                    selectedTheme: selectedTheme,
                    onChanged: (value) {
                      setState(() => selectedTheme = value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  FontSizeSetting(
                    fontSize: fontSize,
                    onChanged: (value) {
                      setState(() => fontSize = value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  WallpaperSetting(
                    selectedWallpaper: chatWallpaper,
                    onChanged: (value) {
                      setState(() => chatWallpaper = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Trò chuyện
            _buildSectionTitle('Trò chuyện'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SwitchSettingTile(
                    icon: Icons.visibility_outlined,
                    title: 'Hiển thị trạng thái online',
                    subtitle: 'Cho phép bạn bè thấy khi bạn đang trực tuyến',
                    value: showOnlineStatus,
                    onChanged: (value) {
                      setState(() => showOnlineStatus = value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  SwitchSettingTile(
                    icon: Icons.done_all_outlined,
                    title: 'Xác nhận đã đọc',
                    subtitle: 'Gửi thông báo khi bạn đã đọc tin nhắn',
                    value: readReceipts,
                    onChanged: (value) {
                      setState(() => readReceipts = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tải xuống tự động
            _buildSectionTitle('Tải xuống tự động'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SwitchSettingTile(
                    icon: Icons.image_outlined,
                    title: 'Hình ảnh',
                    subtitle: 'Tự động tải hình ảnh khi có wifi',
                    value: autoDownloadImages,
                    onChanged: (value) {
                      setState(() => autoDownloadImages = value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  SwitchSettingTile(
                    icon: Icons.videocam_outlined,
                    title: 'Video',
                    subtitle: 'Tự động tải video khi có wifi',
                    value: autoDownloadVideos,
                    onChanged: (value) {
                      setState(() => autoDownloadVideos = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Âm thanh & Rung
            _buildSectionTitle('Âm thanh & Rung'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SwitchSettingTile(
                    icon: Icons.volume_up_outlined,
                    title: 'Âm thanh',
                    subtitle: 'Phát âm thanh khi có tin nhắn mới',
                    value: soundEnabled,
                    onChanged: (value) {
                      setState(() => soundEnabled = value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  SwitchSettingTile(
                    icon: Icons.vibration_outlined,
                    title: 'Rung',
                    subtitle: 'Rung khi có tin nhắn mới',
                    value: vibrationEnabled,
                    onChanged: (value) {
                      setState(() => vibrationEnabled = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Khác
            _buildSectionTitle('Khác'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SimpleSettingTile(
                    icon: Icons.storage_outlined,
                    title: 'Quản lý bộ nhớ',
                    subtitle: '2.4 GB đã sử dụng',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  SimpleSettingTile(
                    icon: Icons.lock_outline,
                    title: 'Quyền riêng tư',
                    subtitle: 'Cài đặt quyền riêng tư của bạn',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  SimpleSettingTile(
                    icon: Icons.security_outlined,
                    title: 'Bảo mật',
                    subtitle: 'Mật khẩu, xác thực 2 bước',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  SimpleSettingTile(
                    icon: Icons.help_outline,
                    title: 'Trợ giúp',
                    subtitle: 'Câu hỏi thường gặp, liên hệ hỗ trợ',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  SimpleSettingTile(
                    icon: Icons.info_outline,
                    title: 'Giới thiệu',
                    subtitle: 'Phiên bản 2.5.1',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ==================== LANGUAGE SETTING ====================
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

// ==================== THEME SETTING ====================
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

// ==================== FONT SIZE SETTING ====================
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

// ==================== WALLPAPER SETTING ====================
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

// ==================== SWITCH SETTING TILE ====================
class SwitchSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchSettingTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0288D1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0288D1), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0288D1),
          ),
        ],
      ),
    );
  }
}

// ==================== SIMPLE SETTING TILE ====================
class SimpleSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SimpleSettingTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              child: Icon(icon, color: const Color(0xFF0288D1), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
