class Article {
  final int id;
  final String title;
  final String body;
  final String imageUrl;
  final String date;
  bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.date,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      // Tạo ảnh ngẫu nhiên từ picsum dựa vào ID
      imageUrl: 'https://picsum.photos/id/${json['id']}/400/250',
      date: '16-04-2026',
    );
  }
}