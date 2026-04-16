import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/news_provider.dart';
import 'views/detail_screen.dart'; // NẾU BÁO LỖI VÀNG/ĐỎ: Hãy kiểm tra lại dòng này và class DetailScreen ở dưới

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NewsProvider()..loadNews(),
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App',
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Tin tức tổng hợp' : 'Danh sách yêu thích',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // === MENU 3 GẠCH NẰM Ở ĐÂY ===
      drawer: Drawer(
        child: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // Phần đầu (Header) của Menu 3 gạch
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.menu_book, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text('News App Pro', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Cập nhật tin tức mỗi ngày', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),

                // === CÁC TAB ĐIỀU HƯỚNG ===
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Tin tức tổng hợp', style: TextStyle(fontWeight: FontWeight.bold)),
                  selected: _currentIndex == 0,
                  onTap: () {
                    setState(() => _currentIndex = 0);
                    Navigator.pop(context); // Đóng menu lại sau khi chọn
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: const Text('Danh sách yêu thích', style: TextStyle(fontWeight: FontWeight.bold)),
                  selected: _currentIndex == 1,
                  onTap: () {
                    setState(() => _currentIndex = 1);
                    Navigator.pop(context); // Đóng menu lại sau khi chọn
                  },
                ),

                const Divider(), // Đường kẻ ngang phân cách
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Text('CÀI ĐẶT', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ),

                // === CÁC NÚT CÀI ĐẶT ===
                SwitchListTile(
                  title: const Text('Giao diện Tối'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: provider.isDarkMode,
                  onChanged: (bool value) {
                    provider.toggleTheme(value);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Colors.red),
                  title: const Text('Xóa tất cả tin đã lưu', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context); // Đóng menu trước
                    if (provider.favoriteArticles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Danh sách yêu thích đang trống!')));
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content: const Text('Bạn có chắc chắn muốn xóa toàn bộ danh sách yêu thích không?'),
                          actions: [
                            TextButton(child: const Text('Hủy'), onPressed: () => Navigator.of(context).pop()),
                            TextButton(
                              child: const Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                provider.clearAllFavorites();
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa toàn bộ danh sách')));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Thông tin ứng dụng'),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: 'News App',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.article, size: 50, color: Colors.blue),
                      children: const [Text('Ứng dụng đọc báo được phát triển bằng Flutter.')],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),

      // Nội dung màn hình chính
      body: _currentIndex == 0 ? const HomeTab() : const FavoriteTab(),
    );
  }
}

// === TAB TIN TỨC (HOME) ===
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(provider.errorMessage), backgroundColor: colorScheme.error),
            );
          });
        }
        return Container(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm tin tức...',
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) => provider.search(value),
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                  onRefresh: provider.loadNews,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: provider.articles.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final article = provider.articles[index];
                      return InkWell(
                        // NẾU BÁO ĐỎ Ở ĐÂY, SỬA CHỮ 'DetailScreen' THÀNH TÊN ĐÚNG CỦA BẠN
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(article: article))),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                                child: Image.network(article.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(article.date, style: TextStyle(color: colorScheme.outline, fontSize: 12)),
                                      const SizedBox(height: 6),
                                      Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// === TAB YÊU THÍCH ===
class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favoriteArticles;
        if (favorites.isEmpty) {
          return const Center(child: Text("Chưa có bài viết yêu thích nào!", style: TextStyle(fontSize: 16)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final article = favorites[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(article.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                ),
                title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.toggleFavorite(article);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Đã xóa khỏi danh sách yêu thích'),
                        duration: const Duration(milliseconds: 1500),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                      ),
                    );
                  },
                ),
                // NẾU BÁO ĐỎ Ở ĐÂY, SỬA CHỮ 'DetailScreen' THÀNH TÊN ĐÚNG CỦA BẠN
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(article: article))),
              ),
            );
          },
        );
      },
    );
  }
}