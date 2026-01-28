// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
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
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        if (state.listFriendRequests.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.no_friend_requests_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        }

        // Filter friend requests based on search query
        final filteredRequests =
            state.listFriendRequests.where((user) {
              if (widget.searchQuery.isEmpty) return true;
              return user.userName.toLowerCase().contains(widget.searchQuery) ||
                  user.email.toLowerCase().contains(widget.searchQuery);
            }).toList();

        if (filteredRequests.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.no_results_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              backgroundColor: colorScheme.onSurface.withOpacity(0.1),
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
                        (context) =>
                            ProfileDetailPage(user: request, isViewOnly: true),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.userName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: colorScheme.onSurface.withOpacity(0.6),
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
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: const Size(90, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.accept_action,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _handleReject(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onSurface.withOpacity(0.7),
                  side: BorderSide(
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  minimumSize: const Size(90, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.reject_action,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
