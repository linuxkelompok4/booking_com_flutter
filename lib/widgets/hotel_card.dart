import 'package:flutter/material.dart';
import '../models/hotel.dart';

class HotelCard extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.onTap,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool isHovered = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // simulate image loading (for shimmer effect)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = isHovered ? 1.03 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: scale,
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isHovered ? 0.15 : 0.08),
                  blurRadius: isHovered ? 20 : 12,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              children: [
                // 🖼 IMAGE WITH SHIMMER
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: isLoading
                          ? _shimmerBox()
                          : Image.asset(
  widget.hotel.image,
  key: const ValueKey("image"),
  fit: BoxFit.cover,
  width: 110,
  height: 110,
)
                    ),
                  ),
                ),

                // 📄 CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hotel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.hotel.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 14),
                            const SizedBox(width: 4),
                            Text("${widget.hotel.rating}"),
                            const SizedBox(width: 6),
                            Text(
                              "(${widget.hotel.reviews})",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.hotel.price,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌫 SHIMMER BOX (simple version)
  Widget _shimmerBox() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}