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
  - Tuỳ chỉnh giao diện (theme) *(tuỳ theo phần bạn đã làm)*
  - Tuỳ chỉnh thông báo *(tu��� theo phần bạn đã làm)*

## Công nghệ sử dụng (Tech stack)
- **Flutter**
- **State Management:** BLoC
- **Backend/Services:** Firebase, Supabase
- **Local DB / Cache:** **Isar**
- **Push Notification:** Firebase Cloud Messaging (FCM)

## Demo
- Link demo: *(bạn sẽ cập nhật sau)*

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

## Cấu trúc thư mục
*(Bạn chưa cung cấp cấu trúc repo. Dưới đây là mẫu tham khảo cho Flutter + BLoC. Mình sẽ chỉnh đúng theo repo khi bạn gửi cây thư mục.)*

```text
Zipo-App/
├─ lib/
│  ├─ core/              # hằng số, utils, config, theme, services...
│  ├─ data/              # datasource, repository impl, models...
│  ├─ domain/            # entities, repositories, usecases...
│  ├─ presentation/      # UI + bloc/cubit, pages, widgets...
│  └─ main.dart
├─ assets/
├─ test/
└─ pubspec.yaml
```

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

## Giấy phép (License)
*(Chưa cung cấp. Bạn có thể thêm loại license như MIT/Apache-2.0 hoặc ghi rõ “Private”.)*
