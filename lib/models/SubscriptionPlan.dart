class SubscriptionPlan {
  final int id;
  final String name;

  SubscriptionPlan({required this.id, required this.name});

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name']
    );
  }
}
