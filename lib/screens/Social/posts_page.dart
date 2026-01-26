// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      showSnackBar.show_success('Bài viết đã được tạo thành công!', context);
    } else if (result == 404) {
      showSnackBar.show_error('Bài viết tạo thất bại!', context);
    }
  }

  Widget _buildProgressWidget() {
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
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Đang đăng bài viết...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700,
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
    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (previous, current) {
        return previous.posts != current.posts ||
            previous.isLoading != current.isLoading;
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Bài viết',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.getFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                _buildProgressWidget(),
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        }
        if (state.errorMessage != null) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Bài viết',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.getFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                _buildProgressWidget(),
                Expanded(
                  child: Center(
                    child: Text(
                      'Lỗi tải bài viết: ${state.errorMessage}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        color: Colors.red,
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
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  'Bài viết',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.getFontSize(context, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
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
                          'Chưa có bài viết nào. Hãy tạo bài viết mới!',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 16),
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                      : Column(
                        children: [
                          _buildProgressWidget(),
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
                                      'Bài viết đã được xóa',
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
                backgroundColor: const Color(0xFF0288D1),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}
