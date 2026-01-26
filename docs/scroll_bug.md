## Scroll Bug

Chào bạn, mình đã kiểm tra mã nguồn của màn hình Chat và phát hiện ra hai nguyên nhân chính gây ra vấn đề cuộn (scroll) không ổn định:

1. Lỗi logic đồng bộ dữ liệu (Chính): Trong MessageService, mỗi khi có tin nhắn mới hoặc thay đổi từ Firestore, mã nguồn cũ gọi clearAllMessages()
. Hàm này không chỉ xóa tin nhắn hiện tại mà xóa toàn bộ lịch sử tin nhắn của tất cả các cuộc trò chuyện trong cơ sở dữ liệu cục bộ (Isar), sau đó mới nạp lại từng tin nhắn một. Điều này khiến danh sách bị trống rồi nạp lại liên tục, gây ra hiện tượng nhảy/cuộn từ đầu khi gửi hoặc nhận tin nhắn.
2. Thứ tự sắp xếp dữ liệu chưa tối ưu: Dữ liệu cục bộ được sắp xếp theo thời gian tăng dần (cũ nhất trước), trong khi ListView sử dụng reverse: true. Mặc dù bạn có tính toán lại index ở UI, nhưng việc này làm giảm tính ổn định khi danh sách thay đổi kích thước.
3. Lệnh cuộn thủ công: Việc gọi jumpTo(0) trong addPostFrameCallback khi mới vào màn hình đôi khi tranh chấp với cơ chế tự động của Flutter, gây ra cảm giác trễ hoặc "nhảy" màn hình.

## Các thay đổi mình đã thực hiện:
#### Tối ưu hóa Isar và MessageService:
- Thêm phương thức syncMessages để cập nhật tin nhắn của một cuộc trò chuyện cụ thể trong một transaction duy nhất.
- Loại bỏ lệnh xóa toàn bộ tin nhắn nguy hiểm khi đang đồng bộ.
#### Thay đổi thứ tự sắp xếp:
- Sắp xếp tin nhắn trong Isar theo thời gian giảm dần (mới nhất ở index 0).
- Đây là cách làm chuẩn khi kết hợp với ListView(reverse: true), giúp các tin nhắn mới "đẩy" các tin nhắn cũ lên trên một cách tự nhiên mà không làm mất vị trí cuộn.
#### Đơn giản hóa ModernChatScreen:
- Loại bỏ logic jumpTo(0) không cần thiết khi mới tải vì reverse: true sẽ tự động mặc định ở vị trí 0 (cuối tin nhắn).
- Cập nhật lại cách tính messageIndex để tương thích với thứ tự sắp xếp mới (rất đơn giản và ổn định hơn).
- Chuyển sang BouncingScrollPhysics để trải nghiệm mượt mà hơn.