import 'package:flutter/material.dart';
import 'package:flutter_supabase_milk_subscription/widgets/CustomDrawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/Product.dart';
import '../models/SubscriptionPlan.dart';
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
      drawer: CustomDrawer(parentContext: context),
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
  final SupabaseClient _supabase = Supabase.instance.client;
  int selectedVariantIndex = 0;
  List<SubscriptionPlan> subscriptionPlans = [];
  SubscriptionPlan? selectedPlan;

  @override
  void initState() {
    super.initState();
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    try {
      final response = await _supabase.from('subscription_plans').select('*');
      if (response.isNotEmpty) {
        setState(() {
          subscriptionPlans = (response as List)
              .map((item) => SubscriptionPlan.fromJson(item))
              .toList();
          selectedPlan = subscriptionPlans.first; // Default selection
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load subscription plans: $e')),
      );
    }
  }

  void _navigateToProductDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: widget.product),
      ),
    );
  }

  Future<void> addToCart() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to your cart')),
      );
      return;
    }

    final product = widget.product;
    final variant = product.variants[selectedVariantIndex];

    try {
      // Use maybeSingle() to get a single matching row or null if none exist
      final existingItem = await _supabase
          .from('carts')
          .select()
          .eq('user_id', user.id)
          .eq('product_id', product.id)
          .eq('variant_id', variant.id)
          .maybeSingle();

      if (existingItem != null) {
        // Increase the quantity if item exists
        final newQty = (existingItem['qty'] as int) + 1;
        await _supabase
            .from('carts')
            .update({'qty': newQty})
            .eq('id', existingItem['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity updated for ${product.name}')),
        );
      } else {
        // Insert a new item if it doesn't exist
        await _supabase.from('carts').insert({
          'product_id': product.id,
          'variant_id': variant.id,
          'qty': 1, // Default quantity
          'price': variant.unitPrice,
          'attributes': {}, // Add any attributes if needed
          'user_id': user.id,
          'subscription_plan_id': selectedPlan?.id
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added to cart')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error adding to cart: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final selectedVariant = product.variants[selectedVariantIndex];

    return InkWell(
      onTap: _navigateToProductDetail,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              GestureDetector(
                onTap: _navigateToProductDetail,
                child: Text(
                  product.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // Variant Selection
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

              // Subscription Plan Dropdown
              if (subscriptionPlans.isNotEmpty) ...[
                const Text(
                  'Select Subscription Plan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<SubscriptionPlan>(
                  value: selectedPlan,
                  isExpanded: true,
                  items: subscriptionPlans.map((plan) {
                    return DropdownMenuItem(
                      value: plan,
                      child: Text(plan.name),
                    );
                  }).toList(),
                  onChanged: (plan) {
                    setState(() {
                      selectedPlan = plan;
                    });
                  },
                ),
                const SizedBox(height: 12),
              ],

              // Price Display
              Text(
                '₹ ${selectedVariant.unitPrice.toString()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('${product.name} added to cart')),
              //       );
              //
              //       addToCart();
              //     },
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: const Text('Add to Cart'),
              //   ),
              // ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
