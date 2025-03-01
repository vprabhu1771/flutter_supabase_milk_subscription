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
      print('Error fetching cart items: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeFromCart(int cartId) async {
    try {
      await supabase.from('carts').delete().eq('id', cartId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );

      await fetchCartItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: $e')),
      );
      print('Error removing item: $e');
    }
  }

  Future<void> clearCart() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to clear your cart')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart"),
        content: const Text("Are you sure you want to remove all items from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Clear"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await supabase.from('carts').delete().eq('user_id', user.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart cleared successfully')),
        );
        await fetchCartItems();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing cart: $e')),
        );
        print('Error clearing cart: $e');
      }
    }
  }

  double getTotalAmount() {
    return cartItems.fold(0, (sum, item) => sum + (item.variants.unitPrice * item.qty));
  }

  Future<void> placeOrder() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to place an order')),
      );
      return;
    }

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    try {
      final orderData = {
        'user_id': user.id,
        'total_amount': getTotalAmount(),
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await supabase.from('orders').insert(orderData).select();

      if (response != null && response.isNotEmpty) {
        final orderId = response[0]['id'];

        for (var item in cartItems) {
          await supabase.from('order_items').insert({
            'order_id': orderId,
            'product_id': item.products.id,
            'variant_id': item.variants.id,
            'quantity': item.qty,
            'unit_price': item.variants.unitPrice,
          });
        }

        await supabase.from('carts').delete().eq('user_id', user.id);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );

        fetchCartItems();
      } else {
        throw Exception("Failed to place order.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
      print('Error placing order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: "Clear Cart",
              onPressed: clearCart,
            ),
        ],
      ),
      drawer: CustomDrawer(parentContext: context),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
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
                                Text(
                                  'Unit Price: ₹ ${item.variants.unitPrice.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeFromCart(item.id),
                            tooltip: 'Remove Item',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: placeOrder,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text('Place Order - ₹ ${getTotalAmount().toStringAsFixed(2)}'),
              ),
            ),
        ],
      ),
    );
  }
}