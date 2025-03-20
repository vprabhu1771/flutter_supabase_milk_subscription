import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/Product.dart';
import '../models/SubscriptionPlan.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  int selectedVariantIndex = 0;
  List<SubscriptionPlan> subscriptionPlans = [];
  SubscriptionPlan? selectedPlan;
  bool isLoadingPlans = true;

  DateTime selectedStartDate = DateTime.now();
  double totalAmount = 0.0;
  double deliveryCharge = 100.0;

  @override
  void initState() {
    super.initState();
    fetchSubscriptionPlans();
    calculateTotalAmount();
  }

  Future<void> fetchSubscriptionPlans() async {
    try {
      final response = await _supabase.from('subscription_plans').select('id, name');
      if (response.isNotEmpty) {
        setState(() {
          subscriptionPlans = (response as List)
              .map((item) => SubscriptionPlan.fromJson(item))
              .toList();
          selectedPlan = subscriptionPlans.first;
          isLoadingPlans = false;
        });
      } else {
        showError('No subscription plans found');
      }
    } catch (e) {
      showError('Error fetching plans: $e');
    }
  }

  void showError(String message) {
    setState(() => isLoadingPlans = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void calculateTotalAmount() {
    final selectedVariant = widget.product.variants[selectedVariantIndex];

    DateTime endDate = DateTime(selectedStartDate.year, selectedStartDate.month + 1, 0);
    int daysRemaining = endDate.difference(selectedStartDate).inDays + 1;

    setState(() {
      totalAmount = selectedVariant.unitPrice * daysRemaining;
      totalAmount += deliveryCharge;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        calculateTotalAmount();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final selectedVariant = product.variants[selectedVariantIndex];

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📷 Product Image
            Center(
              child: product.image_path.isNotEmpty
                  ? Image.network(
                product.image_path,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.image_not_supported, size: 100),
            ),
            const SizedBox(height: 16),

            // 📝 Product Name
            Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Product Description', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),

            // 🛠️ Variants Selection
            const Text('Variants:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: product.variants.asMap().entries.map((entry) {
                final index = entry.key;
                final variant = entry.value;
                return ChoiceChip(
                  label: Text('${variant.qty}'),
                  selected: selectedVariantIndex == index,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedVariantIndex = index;
                        calculateTotalAmount();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Price Display
            Text(
              '₹ ${selectedVariant.unitPrice.toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // 📝 Subscription Plan Dropdown
            const Text('Subscription Plan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            isLoadingPlans
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<SubscriptionPlan>(
              value: selectedPlan,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: subscriptionPlans.map((plan) {
                return DropdownMenuItem(
                  value: plan,
                  child: Text(plan.name, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: (plan) {
                setState(() {
                  selectedPlan = plan;
                });
              },
            ),
            const SizedBox(height: 16),

            // 📅 Start Date Picker
            const Text('Start Date:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectStartDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(selectedStartDate),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Price Display
            Text(
              'Delivery Charge Per Month: ₹ ${deliveryCharge}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // 💵 Total Amount Display
            Text('Total Amount: ₹ ${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 🛒 Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${product.name} with ${selectedPlan?.name ?? 'No Plan'} added to cart. Total: ₹${totalAmount.toStringAsFixed(2)}'),
                    ),
                  );
                },
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
