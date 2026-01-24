import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/screens/profiles/profile_detail_page.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';

class FriendInviteList extends StatefulWidget {
  final List<UserApp> listUsers;
  const FriendInviteList({super.key, required this.listUsers});

  @override
  State<FriendInviteList> createState() => _FriendInviteListState();
}

class _FriendInviteListState extends State<FriendInviteList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<UserApp> localUsers;

  @override
  void initState() {
    super.initState();
    localUsers = List.from(widget.listUsers);
  }

  @override
  void didUpdateWidget(FriendInviteList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listUsers != oldWidget.listUsers) {
      localUsers = List.from(widget.listUsers);
    }
  }

  void toggleInvite(UserApp user) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final bool wasInvited =
        user.requiredAddFriend?.contains(currentUser.uid) ?? false;

    // Optimistic update - cập nhật UI ngay lập tức
    setState(() {
      if (wasInvited) {
        user.requiredAddFriend?.remove(currentUser.uid);
      } else {
        user.requiredAddFriend ??= [];
        user.requiredAddFriend!.add(currentUser.uid);
      }
    });

    // Gửi request đến Bloc
    context.read<UserBloc>().add(
      ToggleFriendRequestEvent(
        user.id,
        !wasInvited,
        currentUserId: currentUser.uid,
      ),
    );
  }

  void navigationToProfile(UserApp user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailPage(user: user, isViewOnly: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: localUsers.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final UserApp user = localUsers[index];
        bool invited =
            user.requiredAddFriend?.contains(_auth.currentUser!.uid) ?? false;
        return BlocListener<UserBloc, UserState>(
          listener: (BuildContext context, state) {
            if (state.error != null) {
              // Revert optimistic update khi có lỗi
              setState(() {
                localUsers = List.from(widget.listUsers);
              });
              showSnackBar.show_error('Gửi lời mời kết bạn thất bại', context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => navigationToProfile(localUsers[index]),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              user.avatarUrl != null &&
                                      user.avatarUrl!.isNotEmpty
                                  ? NetworkImage(user.avatarUrl!)
                                  : const AssetImage(
                                        'assets/images/default-avatar.jpg',
                                      )
                                      as ImageProvider,
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.userName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: invited ? Colors.grey : Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(0, 36), // chiều cao nhỏ hơn
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ), // padding nhỏ lại
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => toggleInvite(user),
                      child: Text(
                        invited ? 'Thu hồi' : 'Kết bạn',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
