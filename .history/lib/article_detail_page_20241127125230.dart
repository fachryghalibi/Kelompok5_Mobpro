import 'package:flutter/material.dart';
import 'package:tubesmopro/service/get_articles.dart';

class ArticleDetailPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailPage({Key? key, required this.articleId}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late Future<Map<String, dynamic>> _articleDetails;

  @override
  void initState() {
    super.initState();
    // Mengambil data artikel berdasarkan articleId
    _articleDetails = GetArticles.fetchArticleDetails(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Article Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _articleDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Article not found.'));
          }

          final article = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['title'] ?? 'No Title',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  article['author'] ?? 'Unknown Author',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(
                  article['content'] ?? 'No content available.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
