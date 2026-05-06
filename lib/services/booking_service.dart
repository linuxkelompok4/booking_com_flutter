class BookingService {
  static List<Map<String, dynamic>> bookings = [];

  static void addBooking(Map<String, dynamic> booking) {
    bookings.add(booking);
  }

  static List<Map<String, dynamic>> getBookings() {
    return bookings;
  }
}