import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tubesmopro/service/get_articles.dart';
import 'package:tubesmopro/article_detail_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: FutureBuilder<List<Map<String, dynamic>>>( // Mengambil data artikel
        future: GetArticles.fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menunggu data
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found.')); // Jika tidak ada artikel
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length, // Jumlah artikel
            itemBuilder: (context, index) {
              final article = articles[index];

              // Pastikan untuk mengkonversi article['id'] menjadi int
              final articleId = int.tryParse(article['id'].toString()) ?? 0;

              return GestureDetector(
                onTap: () {
                  // Navigasi ke halaman detail artikel dengan ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(
                        articleId: articleId, // Kirim articleId ke halaman detail
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: article['imageUrl'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(article['title'] ?? 'No title'), // Menampilkan judul artikel
                    subtitle: Text(article['author'] ?? 'Unknown author'), // Menampilkan penulis
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
