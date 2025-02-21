class Variant {
  final int productId;
  final int id;
  final String qty;
  final String unitPrice;

  Variant({
    required this.productId,
    required this.id,
    required this.qty,
    required this.unitPrice,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      productId: json['product_id'],
      id: json['id'],
      qty: json['qty'],
      unitPrice: json['unit_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'id': id,
      'qty': qty,
      'unit_price': unitPrice,
    };
  }

  factory Variant.placeholder() => Variant(
    id: 0,
    productId: 0,
    qty: 'N/A',
    unitPrice: '0.0',
  );

}