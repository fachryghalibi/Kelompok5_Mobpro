// Fachry
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // depedencies font
import 'package:shimmer/shimmer.dart'; //depedencies 3
import 'package:cached_network_image/cached_network_image.dart'; //depedencies supaya tidak download cache gambar lagi
import 'package:connectivity_plus/connectivity_plus.dart'; //tes koneksi internet
import 'package:tubesmopro/article_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubesmopro/service/get_articles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  bool isConnected = true;
  String username = '';

  // Daftar notifikasi
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Jadwal Konsultasi',
      'message': 'Konsultasi dengan Dr. Atyan akan dimulai dalam 1 jam',
      'time': '10:00',
      'isRead': false,
    },
    {
      'title': 'Hasil Tes',
      'message': 'Hasil tes psikolog Anda telah tersedia',
      'time': 'Kemarin',
      'isRead': true,
    },
    {
      'title': 'Pengingat Obat',
      'message': 'Waktunya minum obat sesuai resep',
      'time': 'Kemarin',
      'isRead': true,
    },
  ];

  // Daftar layanan
  List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Konsultasi Online',
      'description': 'Konsultasi dengan dokter melalui video call',
      'icon': Icons.video_call,
      'color': Colors.blue,
      'route': '/consultation'
    },
    {
      'title': 'Tes Psikolog',
      'description': 'Pemeriksaan psikolog dan tes kesehatan lainnya',
      'icon': Icons.science,
      'color': Colors.green,
      'route': '/psikolog_tes'
    },
  ];

  // Daftar artikel
  List<Map<String, dynamic>> _allArticles = [];
  List<Map<String, dynamic>> _filteredServices = [];
  List<Map<String, dynamic>> _filteredArticles = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _filteredServices = _allServices;
    _filteredArticles = _allArticles;
    _searchController.addListener(_filterContent);
    _checkConnectivity();
    _loadUsername();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Fetch articles from the database
      final articles = await GetArticles.fetchArticles();

      setState(() {
        _allArticles = articles;
        _filteredArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat artikel. Silakan coba lagi.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('full_name') ?? 'user';
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });

    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContent() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      // Existing filter logic for services
      _filteredServices = _allServices.where((service) {
        return service['title'].toLowerCase().contains(query) ||
            service['description'].toLowerCase().contains(query);
      }).toList();

      // Updated filter logic for articles to work with database-fetched articles
      _filteredArticles = _allArticles.where((article) {
        return article['title'].toLowerCase().contains(query) ||
            article['author'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: !isConnected
          ? _buildNoInternetWidget()
          : RefreshIndicator(
              onRefresh: () async {
                //refresh logic
                await Future.delayed(Duration(seconds: 1));
                setState(() {});
              },
              child: _buildBody(),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Telkom Medika',
        style: GoogleFonts.lato(
          color: const Color.fromARGB(255, 255, 17, 0),
          fontWeight: FontWeight.w900,
          fontSize: 30,
        ),
      ),
      actions: [
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon:
              Icon(Icons.notifications, color: Theme.of(context).primaryColor),
          onPressed: () => _showNotificationDialog(context),
        ),
        Positioned(
          right: 11,
          top: 11,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              '1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada koneksi internet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: _checkConnectivity,
              child: Text('Coba Lagi'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          _buildSearchBar(),
          SizedBox(height: 30),
          _buildQuickActionsSection(),
          SizedBox(height: 30),
          _buildMainServicesSection(),
          SizedBox(height: 30),
          _buildArticlesSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            '$username!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 226, 226, 226),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(),
          decoration: InputDecoration(
            hintText: 'Cari layanan atau artikel kesehatan...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildQuickAction(
              context, 'Profil', Icons.person, Colors.purple, '/profile'),
          _buildQuickAction(context, 'Booking', Icons.calendar_today,
              Colors.blue, '/booking'),
          _buildQuickAction(context, 'Jadwal', Icons.schedule, Colors.teal,
              '/doctor_schedule'),
          _buildQuickAction(context, 'Riwayat', Icons.history, Colors.orange,
              '/health_history'),
          _buildQuickAction(context, 'Darurat', Icons.phone_in_talk, Colors.red,
              '/emergency_contact'),
        ],
      ),
    );
  }

  Widget _buildMainServicesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan Utama',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ..._filteredServices
              .map((service) => _buildServiceCard(
                    context,
                    service['title'],
                    service['description'],
                    service['icon'],
                    service['color'],
                    service['route'],
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildArticlesSection() {
    if (_isLoading) {
      return _buildArticleLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildArticleErrorState();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artikel Kesehatan Terbaru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _filteredArticles.isEmpty
              ? _buildNoArticlesFoundState()
              : Column(
                  children: _filteredArticles
                      .map((article) => _buildArticleCard(
                            article['title'],
                            article['author'],
                            article['readTime'],
                            article['imageUrl'],
                            article['id'], // Pass the article ID
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildArticleLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artikel Kesehatan Terbaru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Create 2 shimmer loading cards
          ...List.generate(
              2,
              (index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Card(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.white,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 15,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  Widget _buildNoArticlesFoundState() {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Tidak ada artikel yang ditemukan.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon,
      Color color, String route) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title,
      String description, IconData icon, Color color, String route) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleErrorState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artikel Kesehatan Terbaru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            color: Colors.red[50],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchArticles,
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String author, String readTime,
      String imageUrl, String articleId) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () async {
          try {
            final id = int.tryParse(
                articleId); // Menggunakan tryParse untuk mencegah exception
            if (id == null) {
              throw Exception("Invalid article ID");
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailPage(
                  articleId: id,
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memuat detail artikel: $e')),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          author,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.access_time, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          readTime,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                        height: 80,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.notifications, color: Theme.of(context).primaryColor),
              SizedBox(width: 8),
              Text(
                'Notifikasi',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification['isRead']
                        ? Colors.grey[300]
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.notifications,
                      color: notification['isRead']
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    notification['title'],
                    style: TextStyle(
                      fontWeight: notification['isRead']
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['message'],
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      notification['isRead'] = true;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Tutup',
                style: TextStyle(),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
