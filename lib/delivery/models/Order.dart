class Order {
  final String time;
  final String location;
  final String customer;
  final String address;
  final List<String> items;
  final String paymentStatus;
  final double lat; // Added latitude field
  final double lan; // Added longitude field

  Order({
    required this.time,
    required this.location,
    required this.customer,
    required this.address,
    required this.items,
    required this.paymentStatus,
    required this.lat,
    required this.lan,
  });

  /// Factory method to create an Order from a Map (useful for JSON parsing)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      customer: map['customer'] ?? '',
      address: map['address'] ?? '',
      items: List<String>.from(map['items'] ?? []),
      paymentStatus: map['paymentStatus'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(), // Parsing latitude
      lan: (map['lan'] ?? 0.0).toDouble(), // Parsing longitude
    );
  }

  /// Converts the Order object to a Map (useful for sending data)
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'location': location,
      'customer': customer,
      'address': address,
      'items': items,
      'paymentStatus': paymentStatus,
      'lat': lat, // Added latitude to map
      'lan': lan, // Added longitude to map
    };
  }
}
