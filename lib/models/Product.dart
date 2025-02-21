import 'Variant.dart';

class Product {
  final int id;
  final String name;
  final String image_path;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.image_path,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var variantsJson = json['variants'] as List;
    List<Variant> variantList =
    variantsJson.map((variant) => Variant.fromJson(variant)).toList();

    return Product(
      id: json['id'],
      name: json['name'],
      image_path: json['image_path'],
      variants: variantList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_path': image_path,
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }

  factory Product.placeholder() => Product(
    id: 0,
    name: 'Unknown Product',
    image_path: '',
    variants: [],
  );

}