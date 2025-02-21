import 'dart:core';
import 'SubscriptionPlan.dart';

class Cart {
  final int id;
  final int productId;
  final int variantId;
  final int qty;
  final double price;
  final Map<String, dynamic> attributes;
  final DateTime createdAt;
  final String userId;
  final Product products;
  final Variant variants;
  // final int? subscriptionPlanId;
  // final SubscriptionPlan? subscriptionPlan;

  Cart({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.qty,
    required this.price,
    required this.attributes,
    required this.createdAt,
    required this.userId,
    required this.products,
    required this.variants,
    // this.subscriptionPlanId,
    // this.subscriptionPlan,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      qty: json['qty'],
      price: (json['price'] as num).toDouble(),
      attributes: json['attributes'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      products: Product.fromJson(json['products']),
      variants: Variant.fromJson(json['variants']),
      // subscriptionPlan: json['subscription_plans'] != null
      //     ? SubscriptionPlan.fromJson(json['subscription_plans'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant_id': variantId,
      'qty': qty,
      'price': price,
      'attributes': attributes,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'products': products.toJson(),
      'variants': variants.toJson(),
      // 'subscriptionPlan': subscriptionPlan.toJson(),
    };
  }
}

class Product {
  final int id;
  final String name;
  final DateTime createdAt;
  final String imagePath;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.imagePath,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      imagePath: json['image_path'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'image_path': imagePath,
      'description': description,
    };
  }
}

class Variant {
  final int id;
  final String qty;
  final int productId;
  final double unitPrice;

  Variant({
    required this.id,
    required this.qty,
    required this.productId,
    required this.unitPrice,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      qty: json['qty'],
      productId: json['product_id'],
      unitPrice: double.parse(json['unit_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'product_id': productId,
      'unit_price': unitPrice,
    };
  }
}