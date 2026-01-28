// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/bloc/post/postBloc.dart';
import 'package:maintain_chat_app/bloc/post/postEvent.dart';
import 'package:maintain_chat_app/bloc/post/postState.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/models/post_models.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';
import '../../utils/responsive_helper.dart';
import 'post_card.dart';
import 'create_post_page.dart';

class PostsPage extends StatefulWidget {
  // ignore: use_super_parameters
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool _hideProgressWidget = true;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    context.read<PostBloc>().add(LoadPosts());
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      final postState = context.read<PostBloc>().state;
      final userState = context.read<UserBloc>().state;

      if (postState.posts.isNotEmpty && userState.userApp != null) {
        setState(() {
          _isLoadingMore = true;
        });

        // Lấy bài viết cũ nhất (bài viết cuối trong danh sách)
        final lastPost = postState.posts.last;
        if (lastPost.createdAt != null) {
          context.read<PostBloc>().add(
            LoadMorePosts(lastPost.createdAt!, userState.userApp!),
          );
        }

        // Reset flag sau một khoảng thời gian
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void createNewPost() async {
    setState(() {
      _hideProgressWidget = false; // Show progress
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostPage()),
    );

    // Hide progress after returning
    if (mounted) {
      setState(() {
        _hideProgressWidget = true;
      });
    }
    if (result != null && result is PostItem) {
      showSnackBar.show_success(
        AppLocalizations.of(context)!.create_post_success,
        context,
      );
    } else if (result == 404) {
      showSnackBar.show_error(
        AppLocalizations.of(context)!.create_post_failed,
        context,
      );
    }
  }

  Widget _buildProgressWidget(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _hideProgressWidget ? 0 : 60,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _hideProgressWidget ? 0 : 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.posting_placeholder,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (previous, current) {
        return previous.posts != current.posts ||
            previous.isLoading != current.isLoading;
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.posts_title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.getFontSize(context, 24),
                ),
              ),
            ),
            body: Column(
              children: [
                _buildProgressWidget(theme, colorScheme),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state.errorMessage != null) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.posts_title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.getFontSize(context, 24),
                ),
              ),
            ),
            body: Column(
              children: [
                _buildProgressWidget(theme, colorScheme),
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.error_loading_posts(state.errorMessage!),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        final posts = state.posts;
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            final currentUserId = userState.userApp?.id;
            return Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: colorScheme.surface,
                surfaceTintColor: colorScheme.surface,
                title: Text(
                  AppLocalizations.of(context)!.posts_title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getFontSize(context, 24),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: colorScheme.onSurface,
                      size: ResponsiveHelper.getFontSize(context, 24),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              body:
                  posts.isEmpty
                      ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_posts_message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: ResponsiveHelper.getFontSize(context, 16),
                            color: theme.disabledColor,
                          ),
                        ),
                      )
                      : Column(
                        children: [
                          _buildProgressWidget(theme, colorScheme),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return PostCard(
                                  post: posts[index],
                                  currentUserId: currentUserId,
                                  onDelete: () {
                                    context.read<PostBloc>().add(
                                      DeletePost(posts[index].id ?? ''),
                                    );
                                    showSnackBar.show_success(
                                      AppLocalizations.of(
                                        context,
                                      )!.post_deleted_message,
                                      context,
                                    );
                                  },
                                  onToggleLike: (postId, isLike) {
                                    context.read<PostBloc>().add(
                                      ToggleLike(postId, isLike),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewPost,
                backgroundColor: colorScheme.primary,
                elevation: 4,
                child: Icon(Icons.add, color: colorScheme.onPrimary),
              ),
            );
          },
        );
      },
    );
  }
}
