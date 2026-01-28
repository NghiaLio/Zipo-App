import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
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
      separatorBuilder:
          (_, __) => Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
      itemBuilder: (context, index) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
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
              showSnackBar.show_error(
                AppLocalizations.of(context)!.friend_request_fail,
                context,
              );
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
                          backgroundColor: theme.disabledColor.withOpacity(0.1),
                          backgroundImage:
                              user.avatarUrl != null &&
                                      user.avatarUrl!.isNotEmpty
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                          radius: 24,
                          child:
                              user.avatarUrl == null || user.avatarUrl!.isEmpty
                                  ? Icon(
                                    Icons.person,
                                    color: theme.disabledColor,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.userName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
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
                        backgroundColor:
                            invited
                                ? theme.disabledColor.withOpacity(0.2)
                                : colorScheme.primary,
                        foregroundColor:
                            invited
                                ? colorScheme.onSurface.withOpacity(0.6)
                                : colorScheme.onPrimary,
                        elevation: invited ? 0 : 2,
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
                        invited
                            ? AppLocalizations.of(context)!.revoke_action
                            : AppLocalizations.of(context)!.add_friend_action,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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
