import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giới thiệu',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/Brand Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0288D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Maintain Chat App',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phiên bản 1.0.0',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // About App Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Về ứng dụng',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Maintain Chat App là một ứng dụng nhắn tin hiện đại được thiết kế để kết nối mọi người một cách dễ dàng và bảo mật. Với giao diện thân thiện và tính năng phong phú, ứng dụng mang đến trải nghiệm trò chuyện tuyệt vời cho người dùng.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Features Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tính năng chính',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.message,
                    'Nhắn tin thời gian thực',
                    'Gửi và nhận tin nhắn tức thì với bạn bè',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.image,
                    'Chia sẻ hình ảnh & video',
                    'Chia sẻ khoảnh khắc với chất lượng cao',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.people,
                    'Quản lý bạn bè',
                    'Kết nối và quản lý danh sách bạn bè dễ dàng',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.notifications,
                    'Thông báo thông minh',
                    'Nhận thông báo quan trọng kịp thời',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.security,
                    'Bảo mật cao',
                    'Dữ liệu được mã hóa và bảo vệ an toàn',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Company Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Về chúng tôi',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Maintain Chat App được phát triển bởi đội ngũ kỹ sư tài năng với sứ mệnh tạo ra những sản phẩm công nghệ chất lượng cao, góp phần kết nối cộng đồng và nâng cao trải nghiệm số.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Liên hệ với chúng tôi:',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: support@maintainchat.com\nWebsite: www.maintainchat.com\nHotline: 1900-xxxx',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Copyright
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '© 2024 Maintain Chat App. Tất cả quyền được bảo lưu.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 12),
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0288D1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF0288D1), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 12),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
