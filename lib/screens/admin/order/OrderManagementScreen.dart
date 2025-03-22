import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_supabase_milk_subscription/screens/admin/order/OrderDetailScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/Customer.dart';

class OrderManagementScreen extends StatefulWidget {

  final String title;

  const OrderManagementScreen({super.key, required this.title});

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {

  final SupabaseClient supabase = Supabase.instance.client;

  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _subscribeToRealtimeUpdates();
  }

  Future<void> _fetchCustomers() async {
    final response = await supabase.from('users').select();
    final List<Customer> fetchedCustomers = response
        .map<Customer>((json) => Customer.fromJson(json))
        .toList();

    setState(() {
      customers = fetchedCustomers;
    });
  }

  void _subscribeToRealtimeUpdates() {
    supabase.from('users').stream(primaryKey: ['id']).listen((data) {
      final List<Customer> updatedCustomers = data
          .map<Customer>((json) => Customer.fromJson(json))
          .toList();
      setState(() {
        customers = updatedCustomers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Management')),
      body: customers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                // SlidableAction(
                //   onPressed: (context) => _navigateToDetail(customer),
                //   backgroundColor: Colors.blue,
                //   icon: Icons.edit,
                //   label: 'Edit',
                // ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                // SlidableAction(
                //   onPressed: (context) => _deleteCustomer(index),
                //   backgroundColor: Colors.red,
                //   icon: Icons.delete,
                //   label: 'Delete',
                // ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(child: Text(customer.name[0].toUpperCase())),
              title: Text(customer.name),
              subtitle: Text(customer.email),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: ()  {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderDetailScreen(title: 'Order Detail',))
                  );
              },
            ),
          );
        },
      )
    );
  }
}

// Order Detail Page
