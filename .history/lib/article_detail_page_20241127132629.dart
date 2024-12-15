import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tubesmopro/service/get_articles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:like_button/like_button.dart';

class ArticleDetailPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailPage({Key? key, required this.articleId}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isBookmarked = false;
  bool isLiked = false;
  int likeCount = 0;
  late Future<Map<String, dynamic>> _articleDetails;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Fetch the article details when the page is initialized
    _articleDetails = GetArticles.fetchArticleDetails(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _articleDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return _buildErrorState('Data artikel tidak ditemukan');
          }

          final article = snapshot.data!;

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(article),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(article),
                      const SizedBox(height: 12),
                      _buildAuthorInfo(article),
                      _buildEngagementSection(),
                      const SizedBox(height: 16),
                      _buildContent(article),
                      const SizedBox(height: 20),
                      _buildTagsSection(),
                      const SizedBox(height: 20),
                      _buildRelatedArticles(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildEngagementSection() {
    return Row(
      children: [
        LikeButton(
          size: 30,
          isLiked: isLiked,
          likeCount: likeCount,
          countBuilder: (count, isLiked, text) {
            return Text(
              count.toString(),
              style: TextStyle(
                color: isLiked ? Colors.red : Colors.grey,
              ),
            );
          },
          likeBuilder: (bool isLiked) {
            return Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 30,
            );
          },
          onTap: (bool isLiked) async {
            setState(() {
              this.isLiked = !this.isLiked;
              this.isLiked ? likeCount++ : likeCount--;
            });
            return !isLiked;
          },
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              isBookmarked = !isBookmarked;
            });
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(height: 8),
          Text(errorMessage, style: TextStyle(color: Colors.red)),
          TextButton(
            onPressed: () {
              setState(() {
                _articleDetails = GetArticles.fetchArticleDetails(widget.articleId);
              });
            },
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> article) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: article['image_url'] ?? '', // Make sure image_url is available
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(Map<String, dynamic> article) {
    return Text(
      article['title'] ?? 'Title not available',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAuthorInfo(Map<String, dynamic> article) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            article['author']?.substring(0, 1) ?? 'A',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article['author'] ?? 'Author not available',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                article['read_time'] ?? '0 min read',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Map<String, dynamic> article) {
    final String content = article['content'] ?? 'No content available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.6),
        ),
        if (article['links'] != null && (article['links'] as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildLinks(article),
        ],
      ],
    );
  }

  Widget _buildLinks(Map<String, dynamic> article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Links:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...(article['links'] as List<String>?)?.map((link) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(link)) {
                  await launch(link);
                }
              },
              child: Text(
                link,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          );
        }).toList() ?? [],
      ],
    );
  }

  Widget _buildTagsSection() {
    List<String> tags = ['Kesehatan', 'Tips', 'Lifestyle']; // You can modify this to be dynamic
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Chip(
          label: Text(tag),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        );
      }).toList(),
    );
  }

  Widget _buildRelatedArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Artikel Terkait',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // Modify with your data
            itemBuilder: (context, index) {
              return Card(
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://d1vbn70lmn1nqe.cloudfront.net/prod/wp-content/uploads/2021/06/14042550/Kesehatan-Anak.jpg', // Modify
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Artikel $index', // Modify with actual data
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButtons() {
    return FloatingActionButton(
      onPressed: () {
        Share.share('Check out this article!');
      },
      child: Icon(Icons.share),
    );
  }
}
