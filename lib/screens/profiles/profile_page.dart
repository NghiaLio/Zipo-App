import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/bloc/auth/authBloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/screens/profiles/profile_detail_page.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Cá nhân',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.getFontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.black,
              size: ResponsiveHelper.getFontSize(context, 24),
            ),
            onPressed: () {},
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
                    'Error: ${state.error}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadUserData,
                    child: const Text('Thử lại'),
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
                  const Text('Không tìm thấy thông tin người dùng'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadUserData,
                    child: const Text('Tải lại'),
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
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            user.avatarUrl?.isNotEmpty == true
                                ? user.avatarUrl!
                                : 'https://i.pravatar.cc/150?img=10',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.userName,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 14),
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(context, '234', 'Bài viết'),
                            _buildStatItem(
                              context,
                              user.friends?.length.toString() ?? '0',
                              'Bạn bè',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Thông tin cá nhân',
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
                          icon: Icons.notifications_outlined,
                          title: 'Thông báo',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    child: ProfileMenuItem(
                      icon: Icons.info_outline,
                      title: 'Giới thiệu',
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
                    color: Colors.white,
                    child: ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      onTap: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      textColor: Colors.red,
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
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 14),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
