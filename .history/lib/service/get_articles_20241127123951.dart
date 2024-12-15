import 'dart:convert';
import 'package:http/http.dart' as http;

class GetArticles {
  static const String baseUrl = 'http://10.0.2.2/api_tubes/get_articles.php';

  static Future<List<Map<String, dynamic>>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)); // Perbaikan di sini

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          List<dynamic> articlesData = responseData['articles'];

          return articlesData
              .map((article) => {
                    'id': article['id'].toString(),
                    'title': article['title'] ?? '',
                    'author': article['author'] ?? '',
                    'readTime': article['read_time'] ?? '5 menit baca',
                    'imageUrl': article['image_url']?.trim() ?? '',
                    'content': article['content'] ?? '',
                  })
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchArticleDetails(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl?id=$id')); // Ganti endpoint jika perlu

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Log response body untuk debugging
        print('Response Body: ${response.body}');

        if (responseData['status'] == 'success') {
          final article = responseData['article'];

          // Cek apakah artikel null
          if (article == null) {
            throw Exception('Article not found');
          }

          return {
            'id': article['id'].toString(),
            'title': article['title'] ?? '',
            'author': article['author'] ?? '',
            'readTime': article['read_time'] ?? '5 menit baca',
            'imageUrl': article['image_url']?.trim() ?? '',
            'content': article['content'] ?? '',
          };
        } else {
          throw Exception('Article not found');
        }
      } else {
        throw Exception('Failed to load article');
      }
    } catch (e) {
      print('Error fetching article details: $e');
      rethrow;
    }
  }
}
