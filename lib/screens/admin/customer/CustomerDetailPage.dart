import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/Customer.dart';

class CustomerDetailPage extends StatefulWidget {
  final Customer customer;

  const CustomerDetailPage({super.key, required this.customer});

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Customer? customer;
  List<Map<String, dynamic>> subscriptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  void _fetchCustomerData() async {
    try {
      // Fetch customer details
      final response = await supabase
          .from('users')
          .select('id, name, email, phone')
          .eq('id', widget.customer.id)
          .single();

      // Fetch active subscriptions for the customer
      final subResponse = await supabase
          .from('milk_subscriptions')
          .select('id, plan_name:subscription_plans(name), start_date, end_date, status')
          .eq('customer_id', widget.customer.id)
          .eq('status', 'active');

      print(subResponse.toString());

      if (mounted) {
        setState(() {
          customer = Customer.fromJson(response);
          subscriptions = List<Map<String, dynamic>>.from(subResponse);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer.name)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Details Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Name: ${customer!.name}', style: TextStyle(fontSize: 16)),
                    Text('Email: ${customer!.email}', style: TextStyle(fontSize: 16)),
                    Text('Phone: ${customer!.phone}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Active Subscriptions Section
            Text('Active Subscriptions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            subscriptions.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('No active subscriptions.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.subscriptions, color: Colors.blue),
                    title: Text(
                      sub['plan_name']['name'] ?? 'Unknown Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Start: ${sub['start_date']}\nEnd: ${sub['end_date']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: _getStatusChip(sub['status']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'active':
        chipColor = Colors.green;
        break;
      case 'expired':
        chipColor = Colors.red;
        break;
      case 'cancelled':
        chipColor = Colors.orange;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(status.toUpperCase(), style: TextStyle(color: Colors.white)),
      backgroundColor: chipColor,
    );
  }
}
