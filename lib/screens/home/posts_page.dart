import 'package:flutter/material.dart';
import '../../models/post_models.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/post_card.dart';

class PostsPage extends StatelessWidget {
  // ignore: use_super_parameters
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posts = [
      PostItem(
        authorName: 'Nguyễn Văn A',
        authorAvatar: 'https://i.pravatar.cc/150?img=1',
        timeAgo: '2 giờ',
        content: 'Hôm nay thời tiết đẹp quá! Ai đi chơi với mình không? 🌞',
        imageUrl: 'https://picsum.photos/600/400?random=1',
        likes: 124,
        comments: 18,
      ),
      PostItem(
        authorName: 'Trần Thị B',
        authorAvatar: 'https://i.pravatar.cc/150?img=2',
        timeAgo: '5 giờ',
        content: 'Món ăn hôm nay của mình 😋 Nhìn có ngon không các bạn?',
        imageUrl: 'https://picsum.photos/600/400?random=2',
        likes: 89,
        comments: 12,
      ),
      PostItem(
        authorName: 'Lê Văn C',
        authorAvatar: 'https://i.pravatar.cc/150?img=3',
        timeAgo: '8 giờ',
        content: 'Chuyến du lịch Đà Lạt tuyệt vời! 🏔️',
        imageUrl: 'https://picsum.photos/600/400?random=3',
        likes: 256,
        comments: 34,
      ),
    ];

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
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF0288D1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
