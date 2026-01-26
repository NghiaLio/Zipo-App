import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
        title: const Text(
          'Trợ giúp',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0288D1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Color(0xFF0288D1),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chúng tôi sẵn sàng hỗ trợ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tìm câu trả lời và liên hệ hỗ trợ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Câu hỏi thường gặp'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildFAQItem(
                    'Làm thế nào để gửi tin nhắn?',
                    'Chọn người liên hệ từ danh sách hoặc tìm kiếm, sau đó nhập tin nhắn ở ô chat và nhấn gửi.',
                    Icons.message_outlined,
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    'Làm thế nào để xóa tin nhắn?',
                    'Nhấn giữ vào tin nhắn bạn muốn xóa, sau đó chọn "Xóa" từ menu hiện lên. Bạn có thể xóa cho mình hoặc cho tất cả mọi người.',
                    Icons.delete_outline,
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    'Làm thế nào để thay đổi ảnh đại diện?',
                    'Vào phần Hồ sơ, chạm vào ảnh đại diện hiện tại, sau đó chọn "Thay đổi ảnh" để tải ảnh mới từ thư viện hoặc chụp ảnh.',
                    Icons.account_circle_outlined,
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    'Làm thế nào để tắt thông báo?',
                    'Vào Cài đặt > Thông báo, sau đó tắt các tùy chọn thông báo bạn không muốn nhận.',
                    Icons.notifications_off_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Liên hệ hỗ trợ'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.email_outlined,
                    'Email',
                    'support@chatapp.com',
                    'Gửi email cho chúng tôi',
                  ),
                  const Divider(height: 1),
                  _buildContactItem(
                    Icons.phone_outlined,
                    'Hotline',
                    '1900 xxxx',
                    'Gọi điện hỗ trợ (8:00 - 22:00)',
                  ),
                  const Divider(height: 1),
                  _buildContactItem(
                    Icons.chat_bubble_outline,
                    'Live Chat',
                    'Trò chuyện trực tuyến',
                    'Phản hồi nhanh trong vài phút',
                  ),
                  const Divider(height: 1),
                  _buildContactItem(
                    Icons.language,
                    'Website',
                    'www.chatapp.com/help',
                    'Truy cập trung tâm trợ giúp',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0288D1).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF0288D1),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Thời gian phản hồi trung bình: 2-4 giờ làm việc',
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, IconData icon) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0288D1).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF0288D1), size: 20),
      ),
      title: Text(
        question,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String value,
    String subtitle,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF0288D1).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF0288D1), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0288D1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: () {
        // Handle contact action
      },
    );
  }
}
