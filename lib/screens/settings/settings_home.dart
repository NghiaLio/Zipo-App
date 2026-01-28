import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/theme/themeCubit.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/utils/colorUtils.dart';
import 'package:maintain_chat_app/utils/localeUtils.dart';
import 'package:maintain_chat_app/utils/themeUtils.dart';
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
  late String selectedLanguage;
  late String selectedTheme;
  late double fontSize;
  bool autoDownloadImages = true;
  bool autoDownloadVideos = false;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool showOnlineStatus = true;
  bool readReceipts = true;
  late String chatWallpaper;

  @override
  void initState() {
    chatWallpaper = ColorUtils.colorToHex(
      context.read<ThemeCubit>().state.color ?? const Color(0xFF29B6F6),
    );
    selectedTheme = ThemeUtils.themeModeToString(
      context.read<ThemeCubit>().state.themeMode ?? ThemeMode.system,
    );
    fontSize = context.read<ThemeCubit>().state.fontSize ?? 16.0;
    selectedLanguage = LocaleUtils.localeToString(context.read<ThemeCubit>().state.lang ?? const Locale('vi'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.settings_title,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Giao diện
            _buildSectionTitle(AppLocalizations.of(context)!.interface_section),
            Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  LanguageSetting(
                    selectedLanguage: selectedLanguage,
                    onChanged: (value) {
                      setState(() => selectedLanguage = value);
                      context.read<ThemeCubit>().changeLanguage(value);
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  ThemeSetting(
                    selectedTheme: selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        selectedTheme = value;
                        context.read<ThemeCubit>().changeThemeMode(
                          selectedTheme,
                        );
                      });
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  FontSizeSetting(
                    fontSize: fontSize,
                    onChanged: (value) {
                      setState(() {
                        fontSize = value;
                        context.read<ThemeCubit>().changeFontSize(fontSize);
                      });
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  WallpaperSetting(
                    selectedWallpaper: chatWallpaper,
                    onChanged: (value) {
                      setState(() {
                        chatWallpaper = value;
                        context.read<ThemeCubit>().changeColor(chatWallpaper);
                      });
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
            _buildSectionTitle(AppLocalizations.of(context)!.other_section),
            Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  SimpleSettingTile(
                    icon: Icons.storage_outlined,
                    title:
                        AppLocalizations.of(context)!.storage_management_menu,
                    subtitle:
                        AppLocalizations.of(
                          context,
                        )!.storage_management_subtitle,
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
                    title: AppLocalizations.of(context)!.security_menu,
                    subtitle: AppLocalizations.of(context)!.security_subtitle,
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
                    title: AppLocalizations.of(context)!.help_menu,
                    subtitle: AppLocalizations.of(context)!.help_subtitle,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
