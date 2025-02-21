import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/Product.dart';
import 'ProductDetailScreen.dart';


class ProductScreen extends StatefulWidget {
  final String title;

  const ProductScreen({super.key, required this.title});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  final SupabaseClient _supabase = Supabase.instance.client;

  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await _supabase.from('products')
          // Assuming 'variants' is a related table
          // .select('*, product_variants(*) as variants')
          .select('''
              id,
              name,
              image_path,
              variants:product_variants (
                id,
                product_id,
                qty,
                unit_price
              )
            ''');

      print(response.toString());

      if (response.isNotEmpty) {
        setState(() {
          products = (response as List)
              .map((item) => Product.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        showError('Failed to load products');
      }
    } catch (e) {
      showError('An error occurred: $e');
      print(e);
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchProducts,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(product: product);
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int selectedVariantIndex = 0;

  void _navigateToProductDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final selectedVariant = product.variants[selectedVariantIndex];

    return InkWell(
      onTap: _navigateToProductDetail, // Navigate to product detail on tap
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image (clickable)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.image_path.isNotEmpty
                    ? Image.network(
                  product.image_path,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.image_not_supported, size: 100),
              ),
              const SizedBox(height: 12),

              // Product Name (clickable)
              GestureDetector(
                onTap: _navigateToProductDetail,
                child: Text(
                  product.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // Add to Cart Button (clickable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${product.name} added to cart'),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(height: 12),

              // Variants Selection
              if (product.variants.isNotEmpty) ...[
                const Text(
                  'Select Variant:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: product.variants.asMap().entries.map((entry) {
                    final index = entry.key;
                    final variant = entry.value;
                    return ChoiceChip(
                      label: Text('${variant.qty}'),
                      selected: selectedVariantIndex == index,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedVariantIndex = index;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Price Display
              Text(
                '₹ ${selectedVariant.unitPrice}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}