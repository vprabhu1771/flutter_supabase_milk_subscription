import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/Customer.dart';
import 'AddEditCustomerScreen.dart';
import 'CustomerDetailPage.dart';

class CustomerManagementScreen extends StatefulWidget {
  final String title;

  const CustomerManagementScreen({super.key, required this.title});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
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

  Future<void> _deleteCustomer(int index) async {
    final customerId = customers[index].id;
    await supabase.from('users').delete().match({'id': customerId});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer deleted')),
    );

    _fetchCustomers();
  }

  void _navigateToDetail(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailPage(customer: customer),
      ),
    );
  }

  void _addCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditCustomerScreen(title: 'Add Customer')),
    ).then((_) => _fetchCustomers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Management')),
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
                SlidableAction(
                  onPressed: (context) => _navigateToDetail(customer),
                  backgroundColor: Colors.blue,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _deleteCustomer(index),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(child: Text(customer.name[0].toUpperCase())),
              title: Text(customer.name),
              subtitle: Text(customer.email),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _navigateToDetail(customer),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
