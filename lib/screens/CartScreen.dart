import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Cart.dart';
import '../widgets/CustomDrawer.dart';

class CartScreen extends StatefulWidget {
  final String title;

  const CartScreen({super.key, required this.title});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final supabase = Supabase.instance.client;
  List<Cart> cartItems = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await supabase
          .from('carts')
          .select('''
            *,
            products (*),
            variants:product_variants (
              id,
              product_id,
              qty,
              unit_price
            )       
          ''');

      if (response is List) {
        setState(() {
          cartItems = response
              .map((json) => Cart.fromJson(json as Map<String, dynamic>))
              .toList();
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected response format. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching cart items: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeFromCart(int cartId) async {
    try {
      final response = await supabase.from('carts').delete().eq('id', cartId);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed from cart')),
        );

        // Re-fetch updated cart items
        await fetchCartItems();
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Failed to remove item. Please try again.')),
        // );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error removing item: $e')),
      // );
      print('Error removing item: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: CustomDrawer(parentContext: context),
      body: RefreshIndicator(
        onRefresh: fetchCartItems,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : cartItems.isEmpty
            ? const Center(child: Text('Your cart is empty.'))
            : ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: cartItems.length,
          separatorBuilder: (_, __) => const Divider(thickness: 1, height: 20),
          itemBuilder: (context, index) {
            final item = cartItems[index];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.products.imagePath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 60),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.products.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Variant: ${item.variants.qty}'),
                          Text('Quantity: ${item.qty}'),
                          Text('Unit Price: ₹ ${item.variants.unitPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹ ${(item.variants.unitPrice * item.qty).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFromCart(item.id),
                          tooltip: 'Remove Item',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
