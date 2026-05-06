class Hotel {
  final String id;
  final String name;
  final String location;
  final String image;
  final double rating;
  final int reviews;
  final String price;
  final String description;
  final String category;
  final List<String> facilities;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.description,
    required this.facilities,
     required this.category, 
  });
}