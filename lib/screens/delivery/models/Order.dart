class Order {
  final String time;
  final String location;
  final String customer;
  final String address;
  final List<String> items;
  final String paymentStatus;
  String? deliveryStatus;
  final double lat; // Latitude
  final double lng; // Longitude (Fixed lan → lng)

  Order({
    required this.time,
    required this.location,
    required this.customer,
    required this.address,
    required this.items,
    required this.paymentStatus,
    this.deliveryStatus = 'Pending', // Default to 'Pending'
    required this.lat,
    required this.lng,
  });

  /// **Factory method to create an `Order` from a Map (useful for JSON parsing)**
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      customer: map['customer'] ?? '',
      address: map['address'] ?? '',
      items: List<String>.from(map['items'] ?? []),
      paymentStatus: map['paymentStatus'] ?? '',
      deliveryStatus: map['deliveryStatus'] ?? 'Pending', // Default handling
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
    );
  }

  /// **Converts the `Order` object to a Map (useful for API requests)**
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'location': location,
      'customer': customer,
      'address': address,
      'items': items,
      'paymentStatus': paymentStatus,
      'deliveryStatus': deliveryStatus,
      'lat': lat,
      'lng': lng, // Fixed field name
    };
  }
}
