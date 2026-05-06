import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/booking_service.dart';

class HistoryScreen extends StatelessWidget {
  final String? successMessage;
  const HistoryScreen({super.key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    final bookings = BookingService.getBookings();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // ✅ APPBAR CLEAN PREMIUM
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Booking History",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),

      // ✅ BODY FIX (INI YANG TADI HILANG)
      body: bookings.isEmpty
          ? _emptyState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (successMessage != null)
                  _successBanner(successMessage!),

                const SizedBox(height: 16),

                ...bookings.asMap().entries.map((entry) {
                  int i = entry.key;
                  var b = entry.value;

                  return _bookingCard(b)
                      .animate()
                      .fadeIn(delay: (i * 120).ms)
                      .slideY(begin: 0.2);
                })
              ],
            ),
    );
  }

  // ================= SUCCESS =================
  Widget _successBanner(String msg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(child: Text(msg)),
        ],
      ),
    ).animate().fadeIn();
  }

  // ================= CARD =================
  Widget _bookingCard(Map b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          // 🔥 IMAGE + OVERLAY
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image(
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: b["image"].toString().startsWith('http')
                      ? NetworkImage(b["image"])
                      : AssetImage(b["image"]) as ImageProvider,
                ),
              ),

              // 🌑 GRADIENT
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              // TEXT
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          b["location"],
                          style:
                              const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // STATUS
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "Completed",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          // 🔽 INFO
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          b["date"],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      b["price"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Booking ID: #${b.hashCode.toString().substring(0, 6)}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: Colors.grey)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= EMPTY =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.hotel, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No bookings yet ",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 6),
          Text(
            "Start booking your dream hotel!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}