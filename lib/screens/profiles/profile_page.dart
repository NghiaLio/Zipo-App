import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/bloc/auth/authBloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/screens/profiles/profile_detail_page.dart';
import 'package:maintain_chat_app/screens/profiles/friend_page.dart';
import 'package:maintain_chat_app/screens/settings/settings_home.dart';
import 'about_page.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/profile_menu_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _reloadUserData() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId != null) {
      context.read<UserBloc>().add(LoadUsersEvent(userId));
      // Đợi một chút để đảm bảo data được load
      await Future.delayed(const Duration(milliseconds: 500));
    }
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
        title: Text(
          AppLocalizations.of(context)!.profile_tab,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: colorScheme.onSurface,
              size: ResponsiveHelper.getFontSize(context, 24),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) => previous.userApp != current.userApp,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.error_label}: ${state.error}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadUserData,
                    child: Text(AppLocalizations.of(context)!.retry_button),
                  ),
                ],
              ),
            );
          }

          final user = state.userApp;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.user_not_found),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadUserData,
                    child: Text(AppLocalizations.of(context)!.reload_button),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reloadUserData,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: colorScheme.onSurface.withOpacity(
                            0.1,
                          ),
                          backgroundImage: CachedNetworkImageProvider(
                            user.avatarUrl?.isNotEmpty == true
                                ? user.avatarUrl!
                                : 'https://i.pravatar.cc/150?img=10',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.userName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: ResponsiveHelper.getFontSize(context, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: ResponsiveHelper.getFontSize(context, 14),
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              context,
                              '234',
                              AppLocalizations.of(context)!.posts_stat,
                            ),
                            _buildStatItem(
                              context,
                              user.friends?.length.toString() ?? '0',
                              AppLocalizations.of(context)!.friends_stat,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: colorScheme.surface,
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title:
                              AppLocalizations.of(context)!.personal_info_menu,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProfileDetailPage(user: user),
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.people_outline,
                          title: AppLocalizations.of(context)!.friends_menu,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FriendPage(),
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title:
                              AppLocalizations.of(context)!.notifications_menu,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: colorScheme.surface,
                    child: ProfileMenuItem(
                      icon: Icons.info_outline,
                      title: AppLocalizations.of(context)!.about_menu,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: colorScheme.surface,
                    child: ProfileMenuItem(
                      icon: Icons.logout,
                      title: AppLocalizations.of(context)!.logout_menu,
                      onTap: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      textColor: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Text(
          count,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 14),
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
