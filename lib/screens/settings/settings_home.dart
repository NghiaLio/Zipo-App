import 'package:flutter/material.dart';
import 'widgets/language_setting.dart';
import 'widgets/theme_setting.dart';
import 'widgets/font_size_setting.dart';
import 'widgets/wallpaper_setting.dart';
import 'widgets/simple_setting_tile.dart';
import 'storage_management_screen.dart';
import 'security_screen.dart';
import 'help_screen.dart';

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

            // Trò chuyện - CHƯA ĐƯỢC PHÁT TRIỂN
            // _buildSectionTitle('Trò chuyện'),
            // Container(
            //   color: Colors.white,
            //   child: Column(
            //     children: [
            //       SwitchSettingTile(
            //         icon: Icons.visibility_outlined,
            //         title: 'Hiển thị trạng thái online',
            //         subtitle: 'Cho phép bạn bè thấy khi bạn đang trực tuyến',
            //         value: showOnlineStatus,
            //         onChanged: (value) {
            //           setState(() => showOnlineStatus = value);
            //         },
            //       ),
            //       const Divider(height: 1, indent: 16),
            //       SwitchSettingTile(
            //         icon: Icons.done_all_outlined,
            //         title: 'Xác nhận đã đọc',
            //         subtitle: 'Gửi thông báo khi bạn đã đọc tin nhắn',
            //         value: readReceipts,
            //         onChanged: (value) {
            //           setState(() => readReceipts = value);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 10),

            // Tải xuống tự động - CHƯA ĐƯỢC PHÁT TRIỂN
            // _buildSectionTitle('Tải xuống tự động'),
            // Container(
            //   color: Colors.white,
            //   child: Column(
            //     children: [
            //       SwitchSettingTile(
            //         icon: Icons.image_outlined,
            //         title: 'Hình ảnh',
            //         subtitle: 'Tự động tải hình ảnh khi có wifi',
            //         value: autoDownloadImages,
            //         onChanged: (value) {
            //           setState(() => autoDownloadImages = value);
            //         },
            //       ),
            //       const Divider(height: 1, indent: 16),
            //       SwitchSettingTile(
            //         icon: Icons.videocam_outlined,
            //         title: 'Video',
            //         subtitle: 'Tự động tải video khi có wifi',
            //         value: autoDownloadVideos,
            //         onChanged: (value) {
            //           setState(() => autoDownloadVideos = value);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 10),

            // Âm thanh & Rung - CHƯA ĐƯỢC PHÁT TRIỂN
            // _buildSectionTitle('Âm thanh & Rung'),
            // Container(
            //   color: Colors.white,
            //   child: Column(
            //     children: [
            //       SwitchSettingTile(
            //         icon: Icons.volume_up_outlined,
            //         title: 'Âm thanh',
            //         subtitle: 'Phát âm thanh khi có tin nhắn mới',
            //         value: soundEnabled,
            //         onChanged: (value) {
            //           setState(() => soundEnabled = value);
            //         },
            //       ),
            //       const Divider(height: 1, indent: 16),
            //       SwitchSettingTile(
            //         icon: Icons.vibration_outlined,
            //         title: 'Rung',
            //         subtitle: 'Rung khi có tin nhắn mới',
            //         value: vibrationEnabled,
            //         onChanged: (value) {
            //           setState(() => vibrationEnabled = value);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 10),

            // Khác
            _buildSectionTitle('Khác'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SimpleSettingTile(
                    icon: Icons.storage_outlined,
                    title: 'Quản lý bộ nhớ',
                    subtitle: 'Xem và giải phóng dung lượng',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StorageManagementScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  // SimpleSettingTile(
                  //   icon: Icons.lock_outline,
                  //   title: 'Quyền riêng tư',
                  //   subtitle: 'Cài đặt quyền riêng tư của bạn',
                  //   onTap: () {},
                  // ),
                  // const Divider(height: 1, indent: 16),
                  SimpleSettingTile(
                    icon: Icons.security_outlined,
                    title: 'Bảo mật',
                    subtitle: 'Mật khẩu',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecurityScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  SimpleSettingTile(
                    icon: Icons.help_outline,
                    title: 'Trợ giúp',
                    subtitle: 'Câu hỏi thường gặp, liên hệ hỗ trợ',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                  // const Divider(height: 1, indent: 16),
                  // SimpleSettingTile(
                  //   icon: Icons.info_outline,
                  //   title: 'Giới thiệu',
                  //   subtitle: 'Phiên bản 2.5.1',
                  //   onTap: () {},
                  // ),
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
