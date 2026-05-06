import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/hotel.dart';
import '../widgets/hotel_card.dart';
import 'hotel_detail_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "All";
  String searchQuery = ""; 

   void _openDetail(Hotel e) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HotelDetailScreen(hotel: e),
      ),
    );
  }

  List<Hotel> get filteredHotels {
    final result = hotels.where((h) {
      final matchCategory =
          selectedCategory == "All" || h.category == selectedCategory;

      final matchSearch =
          h.name.toLowerCase().contains(searchQuery) ||
          h.location.toLowerCase().contains(searchQuery);

      return matchCategory && matchSearch;
    }).toList();

    // ⭐ sort by rating tertinggi
    result.sort((a, b) => b.rating.compareTo(a.rating));

    return result;
  }

  int index = 0;

  // ✅ PINDAH KE SINI
  Widget buildImage(String path,
      {double? height, double? width, BoxFit fit = BoxFit.cover}) {
    return Image(
      image: path.startsWith('http')
          ? NetworkImage(path)
          : AssetImage(path) as ImageProvider,
      height: height,
      width: width,
      fit: fit,
    );
  }

  final hotels = [
    Hotel(
      id: "1",
      name: "Paradisus By Melia Bali",
      location: "Bali",
      image: "assets/image/bali.jpg",
      rating: 4.8,
      reviews: 120,
      price: "Rp 1.200.000 ",
      description: "Resort mewah dengan pemandangan pantai",
      facilities: ["WiFi", "Pool", "Spa","Gym"],
      category: "Resort",
    ),
    Hotel(
      id: "2",
      name: "Pullman Lombok Merujani Mandalika",
      location: "Lombok",
      image: "assets/image/lombok.jpg",
      rating: 4.6,
      reviews: 95,
      price: "Rp 1.900.000 ",
      description: "View laut terbaik untuk liburan",
      facilities: ["WiFi", "Restaurant","Pool","Gym"],
      category: "Resort",
    ),
    Hotel(
      id: "3",
      name: "The Trans Luxury Hotel",
      location: "Bandung",
      image: "assets/image/bandung.jpg",
      rating: 4.5,
      reviews: 80,
      price: "Rp 1.200.000 ",
      description: "Udara sejuk pegunungan",
      facilities: ["WiFi", "Parking","Pool","Gym"],
      category: "Hotel",
    ),
    Hotel(
      id: "4",
      name: "Alilla Hotel Solo",
      location: "Solo",
      image: "assets/image/alilla.jpg",
      rating: 4.5,
      reviews: 70,
      price: "Rp 1.250.000 ",
      description: "Hotel dengan view kota solo",
      facilities: ["WiFi", "Parking","Pool","Gym","Restaurant"],
      category: "Hotel",
    ),
    Hotel(
      id: "5",
      name: "Fairmont Jakarta",
      location: "Jakarta",
      image: "assets/image/jkt.jpg",
      rating: 4.7,
      reviews: 90,
      price: "Rp 1.550.000 ",
      description: "Salah satu hotel terbaik di jakarta",
      facilities: ["WiFi", "Parking","Pool","Gym","Restaurant"],
      category: "Hotel",
    ),
    Hotel(
      id: "6",
      name: "The Anvaya Beach Resort",
      location: "Bali",
      image: "assets/image/resort.jpg",
      rating: 4.6,
      reviews: 60,
      price: "Rp 1.650.000 ",
      description: "Resort terbaik di pulau bali",
      facilities: ["WiFi","Pool","Gym","Restaurant"],
      category: "Resort",
    ),
    Hotel(
      id: "7",
      name: "Oneeleven Resort Seminyak",
      location: "Bali",
      image: "assets/image/one.jpg",
      rating: 4.8,
      reviews: 75,
      price: "Rp 1.600.000 ",
      description: "Villa dengan view terbaik di pulau bali",
      facilities: ["WiFi","Pool","Gym","Restaurant"],
      category: "Villa",
    ),
    Hotel(
      id: "8",
      name: "Mentigi Bay Dome Villas",
      location: "Lombok",
      image: "assets/image/mentigi.jpg",
      rating: 4.7,
      reviews: 85,
      price: "Rp 1.500.000 ",
      description: "Villa dengan view terbaik di pulau lombok",
      facilities: ["WiFi","Pool","Gym","Restaurant"],
      category: "Villa",
    ),
    Hotel(
      id: "9",
      name: "The Ritz-Carlton Jakarta Pacific Place",
      location: "Jakarta",
      image: "assets/image/ritz.jpg",
      rating: 4.5,
      reviews: 95,
      price: "Rp 5.500.000 ",
      description: "Hotel bintang 5 terbaik di jakarta",
      facilities: ["WiFi","Pool","Gym","Restaurant"],
      category: "Hotel",
    ),
    Hotel(
      id: "10",
      name: "Merlynn Park Hotel",
      location: "Jakarta",
      image: "assets/image/park.jpg",
      rating: 4.8,
      reviews: 85,
      price: "Rp 1.500.000 ",
      description: "Top 5 Hotel bintang 5 terbaik di jakarta",
      facilities: ["WiFi","Pool","Gym","Restaurant"],
      category: "Hotel",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homePage(),
      const HistoryScreen(),
      ProfileScreen(userName: widget.userName),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: pages[index],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ================= HOME =================
  Widget _homePage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(),
          const SizedBox(height: 20),
          _searchBar(),
          const SizedBox(height: 20),
          _categoryChips(),
          const SizedBox(height: 20),
          _heroBanner(),
          const SizedBox(height: 24),
          _sectionTitle("Recommended"),
          const SizedBox(height: 12),
          _horizontalHotels(),
          const SizedBox(height: 24),
          _sectionTitle("Popular Hotels"),
          const SizedBox(height: 12),
          ..._hotelList(),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${widget.userName}",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideX(begin: -0.2),
            const SizedBox(height: 4),
            Text(
              "Let’s find best hotel for you",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.orange,
          child: Icon(Icons.person, color: Colors.white),
        )
      ],
    );
  }

  // ================= SEARCH =================
Widget _searchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value.toLowerCase();
        });
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.search, color: Colors.orange),
        hintText: "Search hotel, city...",
        border: InputBorder.none,
      ),
    ), // ⭐ INI YANG KURANG (koma)
  ).animate().fadeIn();
}

  // ================= CATEGORY =================
  Widget _categoryChips() {
  final items = ["All", "Hotel", "Villa", "Resort"];

  return SizedBox(
    height: 50,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width / items.length;

        int selectedIndex = items.indexOf(selectedCategory);

        return Stack(
          children: [
            // 🔥 BACKGROUND
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
            ),

            // 🔥 SLIDING INDICATOR
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              left: selectedIndex * itemWidth,
              top: 0,
              bottom: 0,
              child: Container(
                width: itemWidth,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 12,
                    )
                  ],
                ),
              ),
            ),

            // 🔥 TEXT BUTTONS
            Row(
              children: List.generate(items.length, (i) {
                final isSelected = selectedCategory == items[i];

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = items[i];
                      });
                    },
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                        child: Text(items[i]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    ),
  );
}
  // ================= HERO =================
  Widget _heroBanner() {
    final hotel = filteredHotels.isNotEmpty
    ? filteredHotels.first
    : hotels.first;

    return Stack(
      children: [
        ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: buildImage(
    hotel.image,
    height: 180,
    width: double.infinity,
  ),
),
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                hotel.location,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        )
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  // ================= HORIZONTAL =================
  Widget _horizontalHotels() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
       itemCount: filteredHotels.length,
        itemBuilder: (context, i) {
          final h = filteredHotels[i];

          return GestureDetector(
            onTap: () => _openDetail(h),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    child: buildImage(
  h.image,
  height: 110,
  width: double.infinity,
),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      h.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ).animate().fadeIn(delay: (i * 150).ms);
        },
      ),
    );
  }

  // ================= LIST =================
 List<Widget> _hotelList() {
  if (filteredHotels.isEmpty) {
    return [
      const SizedBox(height: 40),
      Column(
        children: const [
          Icon(Icons.search_off, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("Hotel tidak ditemukan "),
        ],
      )
    ];
  }

  return filteredHotels.asMap().entries.map((entry) {
    int i = entry.key;
    Hotel e = entry.value;

    return HotelCard(
      hotel: e,
      onTap: () => _openDetail(e),
    )
        .animate()
        .fadeIn(delay: (400 + (i * 120)).ms)
        .slideY(begin: 0.2);
  }).toList();
}

  // ================= SECTION =================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // ================= NAV =================
  Widget _bottomNav() {
  final items = [
    Icons.home_outlined,
    Icons.history_outlined,
    Icons.person_outline,
  ];

  final activeItems = [
    Icons.home,
    Icons.history,
    Icons.person,
  ];

  final labels = ["Home", "History", "Profile"];

  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 25,
                offset: const Offset(0, 10),
              )
            ],
          ),

          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / 3;

              return Stack(
                children: [
                  // 🔥 INDICATOR FIXED
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    left: index * itemWidth,
                    top: 8,
                    bottom: 8,
                    child: Container(
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),

                  // 🔥 ITEMS
                  Row(
                    children: List.generate(3, (i) {
                      final isActive = index == i;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => index = i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: isActive ? 1.2 : 1,
                                child: Icon(
                                  isActive ? activeItems[i] : items[i],
                                  color: isActive
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                labels[i],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isActive
                                      ? Colors.orange
                                      : Colors.grey,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
}