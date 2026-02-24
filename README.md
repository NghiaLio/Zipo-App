# Zipo-App

Zipo-App là ứng dụng mô phỏng các chức năng **nhắn tin** và **mạng xã hội** tương tự Zalo. Ứng dụng tập trung vào trải nghiệm chat realtime, bảng tin bài viết và các tương tác xã hội cơ bản — đồng thời được thiết kế theo hướng **Offline-first** với cơ chế **caching bằng Isar** để tăng tốc độ tải và cải thiện trải nghiệm khi mạng yếu/không ổn định.

## Điểm nổi bật: Offline-first & Caching (Isar)
Dự án áp dụng mô hình **offline-first** nhằm đảm bảo ứng dụng vẫn hoạt động “mượt” ngay cả khi:
- Mạng chậm hoặc chập chờn
- Người dùng tạm thời mất kết nối
- Cần mở lại dữ liệu nhanh mà không phải chờ tải lại từ server

### Cách tiếp cận tổng quan
- **Isar** được dùng làm **local database/cache** để lưu dữ liệu và phục vụ hiển thị nhanh.
- UI có thể **đọc dữ liệu từ local trước** để hiển thị gần như tức thì (fast-first UI).
- Khi có kết nối mạng, ứng dụng sẽ **lấy dữ liệu mới từ Firebase/Supabase** và cập nhật lại local cache.

> Hiện tại dự án **chưa áp dụng strategy đồng bộ cụ thể** (ví dụ: TTL, stale-while-revalidate, write-queue khi offline, xử lý xung đột). Phần này có thể được bổ sung trong các phiên bản tiếp theo.

## Tính năng chính
- **Nhắn tin realtime**
  - Gửi/nhận tin nhắn theo thời gian thực
- **Mạng xã hội (Social feed)**
  - Đăng bài viết
  - Tương tác **Like** / **Comment**
- **Offline-first & caching (Isar)**
  - Dữ liệu được lưu cục bộ giúp mở ứng dụng nhanh
  - Trải nghiệm ổn định hơn khi mạng yếu/không có mạng
- **Thông báo**
  - Nhận thông báo đẩy qua **FCM (Firebase Cloud Messaging)**
- **Cài đặt**
  - Tuỳ chỉnh giao diện (theme) 
  - Tuỳ chỉnh thông báo 

## Công nghệ sử dụng (Tech stack)
- **Flutter**
- **State Management:** BLoC
- **Backend/Services:** Firebase, Supabase
- **Local DB / Cache:** **Isar**
- **Push Notification:** Firebase Cloud Messaging (FCM)

## Một số giao diện ứng dụng
<p align="center">
  <img src="https://github.com/user-attachments/assets/19d70793-209a-4b07-87bd-c37470b5b917" width="220"/>
  <img src="https://github.com/user-attachments/assets/c9ea423d-dc3f-4768-8569-dbea2976694c" width="220"/>
  <img src="https://github.com/user-attachments/assets/8dacbf5e-375a-4e6d-8286-431a99b73511" width="220"/>
  <img src="https://github.com/user-attachments/assets/bf46e5d9-a1f2-409c-b570-7c82448cec76" width="220"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e04bff98-8ddc-469f-b9e5-2295dbf8b8e2" width="220"/>
  <img src="https://github.com/user-attachments/assets/5f0ac53c-28da-4a95-b129-63d8299c5705" width="220"/>
  <img src="https://github.com/user-attachments/assets/bdba104d-d36a-491a-a70c-f414e5d9b4f9" width="220"/>
  <img src="https://github.com/user-attachments/assets/2abcdbcd-5b50-4cb6-8fae-c817245afcc7" width="220"/>
  <img src="https://github.com/user-attachments/assets/10482897-c5c3-44ce-94b7-f578d6c20470" width="220"/>
</p>

## Demo
<p align="center">
  <video src="https://github.com/user-attachments/assets/a3fcb431-c9f6-4235-879e-65be526c0b60" width="220" controls></video>
</p>

- _Link cài đặt_: *(sẽ cập nhật sau)*

## Cài đặt & chạy dự án (Local)
### 1) Yêu cầu
- Flutter SDK (khuyến nghị dùng phiên bản stable)
- Android Studio / VS Code + Flutter/Dart plugin
- Thiết bị Android/iOS hoặc emulator/simulator

Kiểm tra môi trường:
```bash
flutter doctor
```

### 2) Cài dependencies
```bash
flutter pub get
```

### 3) Chạy ứng dụng
```bash
flutter run
```

## Cấu hình Firebase / Supabase
Vì dự án dùng **Firebase + Supabase**, bạn thường cần:

### Firebase
- Tạo Firebase Project
- Thêm app Android/iOS
- Tải file cấu hình:
  - Android: `google-services.json`
  - iOS: `GoogleService-Info.plist`
- Bật các dịch vụ cần thiết (ví dụ: Auth/Firestore/Storage/FCM tuỳ dự án)

### FCM (Thông báo)
- Cấu hình FCM theo Firebase console
- Đảm bảo app có xử lý quyền thông báo và token thiết bị

### Supabase
- Tạo project Supabase
- Lấy `SUPABASE_URL` và `SUPABASE_ANON_KEY`
- Lưu trong biến môi trường / file config (tuỳ cách bạn triển khai)

## Định hướng phát triển (Tuỳ chọn)
- [ ] Bổ sung strategy offline-first rõ ràng (đề xuất)
  - [ ] **Stale-While-Revalidate:** hiển thị cache trước, refresh nền rồi cập nhật UI
  - [ ] **TTL cache:** đặt thời gian hết hạn cho feed/bài viết
  - [ ] **Write queue khi offline:** lưu thao tác (like/comment/post) và đẩy lên server khi online
  - [ ] **Giải quyết xung đột:** timestamp/version hoặc server-authoritative
- [ ] Trạng thái typing trong chat
- [ ] Báo cáo bài viết / kiểm duyệt nội dung

## Đóng góp
Mọi đóng góp đều được chào đón:
1. Fork repository
2. Tạo nhánh: `git checkout -b feature/ten-tinh-nang`
3. Commit: `git commit -m "feat: ..."`
4. Push: `git push origin feature/ten-tinh-nang`
5. Tạo Pull Request

## Tác giả
- NghiaLio

