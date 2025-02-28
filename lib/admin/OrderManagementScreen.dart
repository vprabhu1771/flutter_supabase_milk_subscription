import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class OrderManagementScreen extends StatefulWidget {

  final String title;

  const OrderManagementScreen({super.key, required this.title});

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  // Dummy order list
  List<Map<String, dynamic>> orders = [
    {'id': '12345', 'customer': 'John Doe', 'status': 'Pending', 'deliveryDate': '2025-03-01'},
    {'id': '67890', 'customer': 'Alice Smith', 'status': 'Completed', 'deliveryDate': '2025-02-28'},
    {'id': '11223', 'customer': 'Bob Johnson', 'status': 'Pending', 'deliveryDate': '2025-03-02'},
  ];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      orders[index]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order status updated to $newStatus')),
    );
  }

  void _assignDelivery(int index) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2026, 12, 31),
      onConfirm: (date) {
        setState(() {
          orders[index]['deliveryDate'] = date.toString().split(' ')[0];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delivery scheduled for ${orders[index]['deliveryDate']}')),
        );
      },
    );
  }

  void _navigateToOrderDetail(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Management')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _updateStatus(index, 'Completed'),
                  backgroundColor: Colors.green,
                  icon: Icons.check,
                  label: 'Complete',
                ),
                SlidableAction(
                  onPressed: (context) => _assignDelivery(index),
                  backgroundColor: Colors.orange,
                  icon: Icons.schedule,
                  label: 'Reschedule',
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.local_shipping, color: order['status'] == 'Completed' ? Colors.green : Colors.red),
              title: Text('Order #${order['id']} - ${order['customer']}'),
              subtitle: Text('Delivery Date: ${order['deliveryDate']}'),
              trailing: Chip(
                label: Text(order['status']),
                backgroundColor: order['status'] == 'Completed' ? Colors.green.shade200 : Colors.red.shade200,
              ),
              onTap: () => _navigateToOrderDetail(order),
            ),
          );
        },
      ),
    );
  }
}

// Order Detail Page
class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${order['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order['customer']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Status: ${order['status']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Delivery Date: ${order['deliveryDate']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
