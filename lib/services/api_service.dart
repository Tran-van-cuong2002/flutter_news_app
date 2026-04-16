import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi tải dữ liệu từ server');
      }
    } catch (e) {
      throw Exception('Không thể kết nối mạng. Vui lòng kiểm tra lại!');
    }
  }
}