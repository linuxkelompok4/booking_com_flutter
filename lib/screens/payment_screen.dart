import 'package:flutter/material.dart';
import '../models/hotel.dart';
import 'history_screen.dart';
import '../services/booking_service.dart';

class PaymentScreen extends StatefulWidget {
  final Hotel hotel;
  const PaymentScreen({super.key, required this.hotel});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  int selected = -1;
  bool isLoading = false;

  final methods = [
    {"name": "BCA Virtual Account", "icon": Icons.account_balance},
    {"name": "Mandiri Transfer", "icon": Icons.account_balance_wallet},
    {"name": "OVO", "icon": Icons.phone_android},
    {"name": "GoPay", "icon": Icons.wallet},
    {"name": "DANA", "icon": Icons.account_balance_wallet},
  ];

  int get price =>
      int.parse(widget.hotel.price.replaceAll(RegExp(r'[^0-9]'), ''));

  int get tax => (price * 0.1).toInt();
  int get total => price + tax;

  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ".",
        )}";
  }

  // ================= PAYMENT PROCESS =================
  void confirmPayment() async {
    if (selected == -1) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    BookingService.addBooking({
      "name": widget.hotel.name,
      "location": widget.hotel.location,
      "image": widget.hotel.image,
      "date": DateTime.now().toString().substring(0, 10),
      "price": formatRupiah(total),
      "status": "Completed"
    });

    if (!mounted) return;

    showSuccessDialog();
  }

  // ================= SUCCESS DIALOG =================
  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value, child: child),
            );
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  "Payment Success ",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text("Your booking has been completed"),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HistoryScreen(
                          successMessage: "Booking successful!",
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text("See Booking"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image(
        height: 70,
        width: 70,
        fit: BoxFit.cover,
        image: path.startsWith('http')
            ? NetworkImage(path)
            : AssetImage(path) as ImageProvider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text("Payment"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HOTEL CARD
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  buildImage(widget.hotel.image),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.hotel.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text(widget.hotel.location,
                            style:
                                const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Text(formatRupiah(price),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // 🔽 CONTENT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Payment Method",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 12),

                  ...methods.asMap().entries.map((e) {
                    final isSelected = selected == e.key;

                    return GestureDetector(
                      onTap: () => setState(() => selected = e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(e.value["icon"] as IconData,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                e.value["name"].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.black,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle,
                                  color: Colors.orange)
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _priceRow("Room Price", formatRupiah(price)),
                        _priceRow("Tax (10%)", formatRupiah(tax)),
                        const Divider(),
                        _priceRow("Total", formatRupiah(total),
                            isBold: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selected == -1 || isLoading
                          ? null
                          : confirmPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Confirm Payment",
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? Colors.orange : Colors.black)),
        ],
      ),
    );
  }
}