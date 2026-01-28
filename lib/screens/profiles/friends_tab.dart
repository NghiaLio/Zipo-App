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

class FriendsTab extends StatelessWidget {
  final String searchQuery;

  const FriendsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentUser = state.userApp;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        if (currentUser == null ||
            currentUser.friends == null ||
            currentUser.friends!.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.no_friends_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        }

        // Filter friends based on search query
        final filteredFriends =
            state.listFriends.where((user) {
              if (searchQuery.isEmpty) return true;
              return user.userName.toLowerCase().contains(searchQuery) ||
                  user.email.toLowerCase().contains(searchQuery);
            }).toList();

        if (filteredFriends.isEmpty) {
          return Center(
            child: Text(
              searchQuery.isEmpty
                  ? AppLocalizations.of(context)!.no_friends_message
                  : AppLocalizations.of(context)!.no_results_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: filteredFriends.length,
          itemBuilder: (context, index) {
            final friend = filteredFriends[index];
            return FriendItem(friend: friend);
          },
        );
      },
    );
  }
}

class FriendItem extends StatelessWidget {
  final UserApp friend;

  const FriendItem({super.key, required this.friend});

  void _showRemoveFriendDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.remove_friend_title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(
                  context,
                )!.remove_friend_confirm(friend.userName),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<UserBloc>().add(
                    ToggleFriendEvent(friend.id, false),
                  );
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.remove_friend_success(friend.userName),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.delete_action,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onError,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(bottomSheetContext),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel_action,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProfileDetailPage(user: friend, isViewOnly: true),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        backgroundImage:
            friend.avatarUrl?.isNotEmpty == true
                ? CachedNetworkImageProvider(friend.avatarUrl!)
                : null,
        child:
            friend.avatarUrl == null || friend.avatarUrl!.isEmpty
                ? Icon(Icons.person, color: colorScheme.primary)
                : null,
      ),
      title: Text(
        friend.userName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: ResponsiveHelper.getFontSize(context, 16),
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      trailing: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: colorScheme.onSurface.withOpacity(0.4),
        ),
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (value) {
          if (value == 'remove') {
            _showRemoveFriendDialog(context);
          }
        },
        itemBuilder:
            (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'remove',
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_remove_outlined,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.remove_friend_title,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
