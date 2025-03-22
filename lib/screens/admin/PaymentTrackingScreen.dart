import 'package:flutter/material.dart';

class PaymentTrackingScreen extends StatefulWidget {

  final String title;

  const PaymentTrackingScreen({super.key, required this.title});
  
  @override
  _PaymentTrackingScreenState createState() => _PaymentTrackingScreenState();
}

class _PaymentTrackingScreenState extends State<PaymentTrackingScreen> {
  List<Map<String, dynamic>> payments = [
    {'id': 'P001', 'customer': 'John Doe', 'amount': 5000, 'status': 'Paid', 'dueDate': '2025-02-28'},
    {'id': 'P002', 'customer': 'Alice Smith', 'amount': 3000, 'status': 'Pending', 'dueDate': '2025-03-05'},
    {'id': 'P003', 'customer': 'Bob Johnson', 'amount': 7000, 'status': 'Pending', 'dueDate': '2025-03-10'},
  ];

  void _recordPayment(int index) {
    setState(() {
      payments[index]['status'] = 'Paid';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${payments[index]['customer']} payment recorded!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.attach_money,
                  color: payment['status'] == 'Paid' ? Colors.green : Colors.red,
                ),
                title: Text('${payment['customer']}'),
                subtitle: Text('Amount: \$${payment['amount']} | Due: ${payment['dueDate']}'),
                trailing: Text(
                  payment['status'],
                  style: TextStyle(
                    color: payment['status'] == 'Paid' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // if (payment['status'] == 'Pending') {
                  //   _recordPayment(index);
                  // }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
