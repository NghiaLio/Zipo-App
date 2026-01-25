### Tree Structure Cho Comments

Comments được lưu flat trong database với field `parent_comment`. Khi load, service sẽ:

1. Lấy tất cả comments từ DB
2. Group children theo parent
3. Recursively attach children vào parents
4. Trả về root comments với nested replies

### Sync Từ Remote

- Stream subscription lắng nghe thay đổi từ Supabase
- Chỉ cache 10 bài viết gần nhất của bạn bè và chính user
- Sắp xếp theo thời gian giảm dần

## Cách Sử Dụng

```dart
final postService = PostService(userRepo);
// Tạo post
await postService.createPost(newPost);
// Lấy comments
final comments = await postService.getAllComments(postId);
```

## Lưu Ý

- Service sử dụng Firebase Auth để lấy current user ID
- Tất cả operations đều async và có error handling
- Comments count được update tự động khi thêm/xóa comment
- Likes count được update tự động khi toggle like

## Logic Đặc Biệt

### Optimistic Update
Tất cả các thao tác (create, update, delete) đều update local cache trước, sau đó sync với remote. Nếu remote fail, sẽ rollback hoặc hiển thị lỗi.

### Tree Structure Cho Comments
Comments được lưu flat trong database với field `parent_comment`. Khi load, service sẽ:
1. Lấy tất cả comments từ DB
2. Group children theo parent
3. Recursively attach children vào parents
4. Trả về root comments với nested replies

## Cách Sử Dụng
```dart
final postService = PostService(userRepo);
// Tạo post
await postService.createPost(newPost);
// Lấy comments
final comments = await postService.getAllComments(postId);
````
## Lưu Ý
- Service sử dụng Firebase Auth để lấy current user ID
- Tất cả operations đều async và có error handling
- Comments count được update tự động khi thêm/xóa comment
- Likes count được update tự động khi toggle like
```