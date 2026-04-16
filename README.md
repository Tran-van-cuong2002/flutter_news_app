# 📰 Flutter News App

Ứng dụng đọc báo tổng hợp được phát triển bằng Flutter, áp dụng mô hình kiến trúc **Clean Architecture (MVVM)** và sử dụng **Provider** để quản lý trạng thái.

## 👨‍🎓 Thông tin sinh viên
- **Họ và tên:** Trần Văn Cường
- **MSSV:** 20222142
- **Lớp:** DC.CNTT 13.10.12

---

## ✨ Tính năng nổi bật
Ứng dụng đáp ứng đầy đủ các yêu cầu cơ bản và nâng cao của một App đọc tin tức:
- **Trang chủ (Tin tức):** Hiển thị danh sách các bài báo mới nhất, kèm hình ảnh, tiêu đề và ngày đăng.
- **Tìm kiếm:** Thanh tìm kiếm thời gian thực giúp lọc bài báo theo từ khóa.
- **Yêu thích:** Thêm hoặc xóa bài viết khỏi danh sách yêu thích bằng biểu tượng trái tim.
- **Cài đặt hệ thống:**
    - Chuyển đổi linh hoạt giữa giao diện Sáng / Tối (Light / Dark Mode).
    - Tùy chọn xóa toàn bộ danh sách bài viết đã lưu.
- **Tối ưu trải nghiệm người dùng (UX):**
    - Hiển thị hiệu ứng tải (`CircularProgressIndicator`) khi đang lấy dữ liệu.
    - Hiển thị thông báo lỗi (`SnackBar`) khi mất kết nối mạng hoặc lỗi API.
- **Điều hướng:** Sử dụng `BottomNavigationBar` hiện đại, thân thiện.

---

## 🛠 Thư viện và Công nghệ sử dụng
- **Framework:** Flutter / Dart
- **Quản lý trạng thái (State Management):** `provider`
- **Giao diện:** Material Design 3

---

## 🚀 Hướng dẫn Cài đặt và Chạy ứng dụng

Đảm bảo máy tính của bạn đã cài đặt [Flutter SDK](https://flutter.dev/docs/get-started/install) và một IDE (Android Studio / VS Code).

**Bước 1:** Clone kho lưu trữ này về máy:
```bash
git clone [https://github.com/Tran-van-cuong2002/flutter_news_app.git](https://github.com/Tran-van-cuong2002/flutter_news_app.git)

Bước 2: Di chuyển vào thư mục dự án:

Bash
cd flutter_news_app
Bước 3: Tải các thư viện phụ thuộc (Dependencies):

Bash
flutter pub get
Bước 4: Chạy ứng dụng trên máy ảo hoặc thiết bị thật:

Bash
flutter run