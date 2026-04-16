import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../viewmodels/news_provider.dart';

class DetailScreen extends StatelessWidget {
  final Article article;
  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Chi tiết tin tức'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          Consumer<NewsProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  article.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: article.isFavorite ? Colors.red : colorScheme.onSurface,
                ),
                onPressed: () {
                  provider.toggleFavorite(article);

                  // Hiển thị thông báo khi Thêm/Xóa yêu thích
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(article.isFavorite
                          ? 'Đã thêm vào danh sách yêu thích'
                          : 'Đã bỏ khỏi danh sách yêu thích'),
                      // Thời gian tắt cực nhanh
                      duration: const Duration(milliseconds: 1500),
                      // Giao diện nổi
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                      backgroundColor: article.isFavorite
                          ? colorScheme.primary
                          : colorScheme.secondary,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 250, color: colorScheme.surfaceVariant, child: const Icon(Icons.broken_image, size: 100)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 16, color: colorScheme.outline),
                      const SizedBox(width: 6),
                      Text(article.date, style: TextStyle(color: colorScheme.outline, fontSize: 14)),
                      const SizedBox(width: 16),
                      Icon(Icons.person, size: 16, color: colorScheme.outline),
                      const SizedBox(width: 6),
                      Text("Tác giả: Admin", style: TextStyle(color: colorScheme.outline, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colorScheme.onSurface, height: 1.2),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    article.body,
                    style: TextStyle(fontSize: 17, color: colorScheme.onSurface, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}