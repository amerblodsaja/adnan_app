import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const PremiumMovieApp());
}

class PremiumMovieApp extends StatelessWidget {
  const PremiumMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineStream Adnan Syafiqri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          secondary: Color(0xFF00C3FF),
          surface: Color(0xFF1C1C27),
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

// =========================================================================
// STRUKTUR DATA FILM (Mencegah Error Dynamic)
// =========================================================================
class Movie {
  final String title;
  final double rating;
  final String year;
  final String image;
  final String desc;

  const Movie({
    required this.title,
    required this.rating,
    required this.year,
    required this.image,
    required this.desc,
  });
}

// Database Film 2026
final List<Movie> movieDatabase = [
  const Movie(title: 'Avengers: Doomsday', rating: 9.5, year: '2026', image: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=600&auto=format&fit=crop', desc: 'Avengers bersatu kembali untuk menghadapi ancaman multiverse terdahsyat.'),
  const Movie(title: 'Spider-Man: Brand New Day', rating: 9.2, year: '2026', image: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?q=80&w=600&auto=format&fit=crop', desc: 'Peter Parker memulai babak baru dalam hidupnya sebagai pelindung New York.'),
  const Movie(title: 'Dune: Part Three', rating: 9.0, year: '2026', image: 'https://images.unsplash.com/photo-1506466010722-395aa2bef877?q=80&w=600&auto=format&fit=crop', desc: 'Kisah epik Paul Atreides berlanjut dalam perang suci di seluruh galaksi.'),
  const Movie(title: 'Blade Runner 2099', rating: 8.8, year: '2025', image: 'https://images.unsplash.com/photo-1518715303843-586e350765b2?q=80&w=600&auto=format&fit=crop', desc: 'Petualangan detektif di dunia neon yang penuh dengan replikan.'),
  const Movie(title: 'The Martian Return', rating: 8.5, year: '2026', image: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=600&auto=format&fit=crop', desc: 'Misi penyelamatan baru di Mars yang penuh rintangan ilmiah.'),
  const Movie(title: 'Avatar: The Seed Bearer', rating: 9.4, year: '2025', image: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=600&auto=format&fit=crop', desc: 'Menelusuri kedalaman lautan dan hutan Pandora yang belum terjamah.'),
];

// =========================================================================
// MAIN SCAFFOLD & BOTTOM NAV
// =========================================================================
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const AuroraBackground(),
          IndexedStack(
            index: _currentIndex,
            children: const [
              HomeFragment(),
              SearchFragment(),
              DownloadsFragment(),
              ProfileFragment(),
            ],
          ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.home_filled, 0),
                      _buildNavItem(Icons.search_rounded, 1),
                      _buildNavItem(Icons.download_rounded, 2),
                      _buildNavItem(Icons.person_rounded, 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent, shape: BoxShape.circle),
        child: Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 26),
      ),
    );
  }
}

// =========================================================================
// SEARCH FRAGMENT (Pencarian Film)
// =========================================================================
class SearchFragment extends StatefulWidget {
  const SearchFragment({super.key});
  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  List<Movie> searchResults = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchResults = movieDatabase;
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchResults = movieDatabase
          .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari film favoritmu...',
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final movie = searchResults[index];
                  return ListTile(
                    leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(movie.image, width: 60, height: 90, fit: BoxFit.cover)),
                    title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${movie.year} • ⭐ ${movie.rating}'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(title: movie.title, imageUrl: movie.image, rating: movie.rating)));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// DOWNLOADS FRAGMENT (Riwayat Unduhan)
// =========================================================================
class DownloadsFragment extends StatelessWidget {
  const DownloadsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unduhan Anda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDownloadItem('Dune: Part Three', '2.4 GB', movieDatabase[2].image),
                  _buildDownloadItem('Spider-Man: Brand New Day', '1.8 GB', movieDatabase[1].image),
                  _buildDownloadItem('Blade Runner 2099', '2.1 GB', movieDatabase[3].image),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadItem(String title, String size, String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(img, width: 80, height: 80, fit: BoxFit.cover)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), Text('$size • Selesai', style: const TextStyle(color: Colors.white54, fontSize: 12))])),
          const SizedBox(width: 10),
          const Icon(Icons.play_circle_fill, color: Color(0xFFE50914), size: 40),
        ],
      ),
    );
  }
}

// =========================================================================
// PROFILE FRAGMENT
// =========================================================================
class ProfileFragment extends StatelessWidget {
  const ProfileFragment({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(radius: 60, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=200&auto=format&fit=crop')),
          const SizedBox(height: 15),
          const Text('Adnan Syafiqri', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('adnan.syafiqri@premium.com', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFE50914), borderRadius: BorderRadius.circular(20)), child: const Text('Premium User', style: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 40),
          _buildProfileTile(Icons.person, 'Ubah Profil'),
          _buildProfileTile(Icons.settings, 'Pengaturan'),
          _buildProfileTile(Icons.logout, 'Keluar'),
        ],
      ),
    );
  }
  
  Widget _buildProfileTile(IconData icon, String title) {
    return ListTile(leading: Icon(icon, color: Colors.white70), title: Text(title), trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54));
  }
}

// =========================================================================
// HOME FRAGMENT (Sudah Disesuaikan Menjadi foto.png)
// =========================================================================
class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              children: [
                // 🌟 MENGGUNAKAN FOTO.PNG ASSET MILIKMU 🌟
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/foto.png', 
                    width: 45, 
                    height: 45, 
                    fit: BoxFit.cover,
                    // Proteksi darurat jika terjadi salah ketik/nama file hilang agar aplikasi tidak crash melainkan memunculkan ikon bawaan
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 45, height: 45, 
                      color: const Color(0xFFE50914), 
                      child: const Icon(Icons.movie_filter_rounded, color: Colors.white)
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'Halo, Adnan Syafiqri!', 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: HeroCarousel()),
        const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: Text('Trending Sekarang', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 10), itemCount: movieDatabase.length,
              itemBuilder: (context, index) {
                final movie = movieDatabase[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(title: movie.title, imageUrl: movie.image, rating: movie.rating))),
                  child: Container(width: 150, margin: const EdgeInsets.symmetric(horizontal: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(movie.image, fit: BoxFit.cover))), const SizedBox(height: 10), Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold))])),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)), 
      ],
    );
  }
}

// =========================================================================
// MOVIE DETAIL SCREEN
// =========================================================================
class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  
  const MovieDetailScreen({super.key, required this.title, required this.imageUrl, required this.rating});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(imageUrl, height: 500, width: double.infinity, fit: BoxFit.cover),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xFF09090F).withOpacity(0.8), const Color(0xFF09090F)]))),
          const SafeArea(child: BackButton(color: Colors.white)),
          Positioned(bottom: 50, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), Text('⭐ $rating | 2026', style: const TextStyle(color: Colors.white70)), const SizedBox(height: 20), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), minimumSize: const Size(double.infinity, 50)), child: const Text('Tonton Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]))
        ],
      ),
    );
  }
}

// =========================================================================
// BACKGROUND AURORA EFFECT
// =========================================================================
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: -50, right: -50, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFE50914).withOpacity(0.1)))), 
        Positioned(bottom: 100, left: -50, child: Container(width: 400, height: 400, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF00C3FF).withOpacity(0.05)))), 
        BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent))
      ],
    );
  }
}

// =========================================================================
// HERO CAROUSEL COMPONENT
// =========================================================================
class HeroCarousel extends StatelessWidget {
  const HeroCarousel({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350, 
      child: PageView.builder(
        itemCount: 3, 
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10), 
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), image: DecorationImage(image: NetworkImage(movieDatabase[index].image), fit: BoxFit.cover))
          );
        }
      )
    );
  }
}