import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/hotel.dart';
import 'payment_screen.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  DateTime? checkIn;
  DateTime? checkOut;
  int guests = 1;
  double totalPrice = 0;

  // 📅 PICK DATE
  Future<void> pickDate({required bool isCheckIn}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkIn = picked;
        } else {
          checkOut = picked;
        }
        calculatePrice();
      });
    }
  }

  // 💰 CALCULATE PRICE
  void calculatePrice() {
    if (checkIn != null && checkOut != null) {
      final nights = checkOut!.difference(checkIn!).inDays;

      if (nights > 0) {
        final pricePerNight =
            double.tryParse(widget.hotel.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

        setState(() {
          totalPrice = nights * pricePerNight * guests;
        });
      }
    }
  }

  // 👥 GUEST COUNTER
  Widget guestCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Guests",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

        Row(
          children: [
            IconButton(
              onPressed: () {
                if (guests > 1) {
                  setState(() {
                    guests--;
                    calculatePrice();
                  });
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),

            Text(
              "$guests",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  guests++;
                  calculatePrice();
                });
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        )
      ],
    );
  }

  // 📅 TILE
  Widget dateTile(String title, DateTime? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.orange),
            const SizedBox(width: 10),
            Text(
              value == null
                  ? "Select $title"
                  : "$title: ${value.day}/${value.month}/${value.year}",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🔥 IMAGE HEADER (FIX FINAL)
SizedBox(
  height: 300,
  width: double.infinity,
  child: Stack(
    children: [
      Hero(
        tag: widget.hotel.id,
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.asset(
            widget.hotel.image,
            fit: BoxFit.cover,
          ),
        ),
      ),

      // gradient overlay
      Container(
        decoration: BoxDecoration(
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
    ],
  ),
),

          // 🔙 BACK
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 📄 CONTENT
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.9,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Text(
                      widget.hotel.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ).animate().fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text(widget.hotel.location),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                            "${widget.hotel.rating} (${widget.hotel.reviews} reviews)"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text("Description",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.hotel.description),

                    const SizedBox(height: 20),

                    // 🏨 BOOKING SECTION
                    const Text(
                      "Booking Details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    dateTile("Check-in", checkIn,
                        () => pickDate(isCheckIn: true)),

                    const SizedBox(height: 10),

                    dateTile("Check-out", checkOut,
                        () => pickDate(isCheckIn: false)),

                    const SizedBox(height: 12),

                    guestCounter(),

                    const SizedBox(height: 120),
                  ],
                ),
              );
            },
          ),

          // 💰 BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1))
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Price",
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        "Rp ${totalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ],
                  ),

                  const Spacer(),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: (checkIn == null || checkOut == null)
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PaymentScreen(hotel: widget.hotel),
                              ),
                            );
                          },
                    child: const Text("Book Now"),
                  )
                ],
              ),
            ).animate().slideY(begin: 1, duration: 400.ms),
          )
        ],
      ),
    );
  }
}