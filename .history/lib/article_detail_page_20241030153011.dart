import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; //shimmer depedencies
import 'package:share_plus/share_plus.dart'; //share depedencies
import 'package:url_launcher/url_launcher.dart'; //url launcher
import 'package:like_button/like_button.dart'; //like depedencies
//ihsan
class ArticleDetailPage extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isBookmarked = false;
  bool isLiked = false; 
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 12),
                  _buildAuthorInfo(),
                  _buildEngagementSection(),
                  const SizedBox(height: 16),
                  _buildContent(),
                  const SizedBox(height: 20),
                  _buildTagsSection(),
                  const SizedBox(height: 20),
                  _buildRelatedArticles(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'bookmark',
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Artikel disimpan' : 'Artikel dihapus dari simpanan'
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            backgroundColor: isBookmarked ? Colors.blue : null,
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'share',
            onPressed: () => _shareArticle(),
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.article['imageUrl'],
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

  Widget _buildTitle() {
    return Text(
      widget.article['title'],
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

   Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            widget.article['author'][0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article['author'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.article['readTime'],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
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
      ],
    );
  }

  Widget _buildEngagementSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEngagementItem(Icons.remove_red_eye, '1.2K Views'),
          _buildEngagementItem(Icons.comment, '8 Comments'),
          _buildEngagementItem(Icons.share, '5 Shares'),
        ],
      ),
    );
  }

  Widget _buildEngagementItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final String content = widget.article['content'] ?? '''
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      
      Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      
      Sub Heading
      
      Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
      
      • Point 1
      • Point 2
      • Point 3
    ''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        // Add any clickable links here if needed
        if (widget.article['links'] != null) ...[
          const SizedBox(height: 16),
          _buildLinks(),
        ],
      ],
    );
  }

  Widget _buildLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Links:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...(widget.article['links'] as List<String>).map((link) {
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
        }).toList(),
      ],
    );
  }

  Widget _buildTagsSection() {
    List<String> tags = ['Kesehatan', 'Tips', 'Lifestyle'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => Chip(
        label: Text(tag),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      )).toList(),
    );
  }

  Widget _buildRelatedArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Artikel Terkait',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/200/100?random=$index',
                        height: 100,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Artikel terkait ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _shareArticle() async {
    await Share.share(
      '${widget.article['title']}\n\nBaca selengkapnya: [URL Artikel]',
      subject: widget.article['title'],
    );
  }
}