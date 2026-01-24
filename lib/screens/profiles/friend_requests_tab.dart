// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/screens/profiles/profile_detail_page.dart';
import '../../utils/responsive_helper.dart';

class FriendRequestsTab extends StatefulWidget {
  final String searchQuery;

  const FriendRequestsTab({super.key, required this.searchQuery});

  @override
  State<FriendRequestsTab> createState() => _FriendRequestsTabState();
}

class _FriendRequestsTabState extends State<FriendRequestsTab> {
  @override
  void initState() {
    super.initState();
    // Load friend requests khi tab được khởi tạo
    context.read<UserBloc>().add(LoadFriendRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.listFriendRequests.isEmpty) {
          return const Center(child: Text('Chưa có lời mời kết bạn nào'));
        }

        // Filter friend requests based on search query
        final filteredRequests =
            state.listFriendRequests.where((user) {
              if (widget.searchQuery.isEmpty) return true;
              return user.userName.toLowerCase().contains(widget.searchQuery) ||
                  user.email.toLowerCase().contains(widget.searchQuery);
            }).toList();

        if (filteredRequests.isEmpty) {
          return const Center(child: Text('Không tìm thấy kết quả'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: filteredRequests.length,
          itemBuilder: (context, index) {
            final request = filteredRequests[index];
            return FriendRequestItem(request: request);
          },
        );
      },
    );
  }
}

class FriendRequestItem extends StatelessWidget {
  final UserApp request;

  const FriendRequestItem({super.key, required this.request});

  void _handleAccept(BuildContext context) {
    context.read<UserBloc>().add(
      ToggleFriendEvent(request.id, true), // true = thêm bạn bè
    );
    // Reload friend requests sau khi chấp nhận
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<UserBloc>().add(LoadFriendRequestsEvent());
    });
  }

  void _handleReject(BuildContext context) {
    final currentUserId = context.read<UserBloc>().state.userApp?.id ?? '';

    context.read<UserBloc>().add(
      RejectFriendRequestEvent(senderId: request.id, receiverId: currentUserId),
    );

    // Reload friend requests sau khi từ chối
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<UserBloc>().add(LoadFriendRequestsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProfileDetailPage(user: request, isViewOnly: true),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 28,
                backgroundImage: CachedNetworkImageProvider(
                  request.avatarUrl?.isNotEmpty == true
                      ? request.avatarUrl!
                      : 'https://i.pravatar.cc/150?img=${request.id.hashCode % 70}',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProfileDetailPage(
                            user: request,
                            isViewOnly: true,
                          ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.userName,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.email,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(context, 14),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _handleAccept(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(90, 36),
                  ),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _handleReject(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(90, 36),
                  ),
                  child: Text(
                    'Từ chối',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
