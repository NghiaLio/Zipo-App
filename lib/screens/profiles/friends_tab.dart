import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
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
        if (currentUser == null ||
            currentUser.friends == null ||
            currentUser.friends!.isEmpty) {
          return const Center(child: Text('Chưa có bạn bè nào'));
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
                  ? 'Chưa có bạn bè nào'
                  : 'Không tìm thấy kết quả',
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Xóa bạn bè',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Bạn có chắc muốn xóa ${friend.userName} khỏi danh sách bạn bè?',
                style: const TextStyle(fontSize: 16),
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
                        'Đã xóa ${friend.userName} khỏi danh sách bạn bè',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xóa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(bottomSheetContext),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Hủy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
        backgroundColor: Colors.blue.shade100,
        backgroundImage:
            friend.avatarUrl?.isNotEmpty == true
                ? CachedNetworkImageProvider(friend.avatarUrl!)
                : null,
        child:
            friend.avatarUrl?.isEmpty == true
                ? Icon(Icons.person, color: Colors.blue.shade700)
                : null,
      ),
      title: Text(
        friend.userName,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, 16),
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (value) {
          if (value == 'remove') {
            _showRemoveFriendDialog(context);
          }
        },
        itemBuilder:
            (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_remove_outlined,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Xóa bạn bè',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
