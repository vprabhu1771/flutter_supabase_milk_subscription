import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsPaymentsScreen extends StatefulWidget {

  final String title;

  const EarningsPaymentsScreen({super.key, required this.title});

  @override
  _EarningsPaymentsScreenState createState() => _EarningsPaymentsScreenState();
}

class _EarningsPaymentsScreenState extends State<EarningsPaymentsScreen> {
  String selectedFilter = 'Daily';
  final List<String> filters = ['Daily', 'Weekly', 'Monthly'];

  final List<Map<String, dynamic>> paymentHistory = [
    {'date': DateTime.now().subtract(Duration(days: 1)), 'amount': 150.00, 'status': 'Paid'},
    {'date': DateTime.now().subtract(Duration(days: 3)), 'amount': 200.00, 'status': 'Pending'},
    {'date': DateTime.now().subtract(Duration(days: 7)), 'amount': 300.00, 'status': 'Paid'},
  ];

  double calculateEarnings() {
    return paymentHistory.fold(0.0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${calculateEarnings().toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.green)),
              ],
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
              items: filters.map((filter) => DropdownMenuItem(
                value: filter,
                child: Text(filter),
              )).toList(),
            ),
            SizedBox(height: 16),
            Text('Payment History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: paymentHistory.length,
                itemBuilder: (context, index) {
                  final history = paymentHistory[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(
                        history['status'] == 'Paid' ? Icons.check_circle : Icons.pending_actions,
                        color: history['status'] == 'Paid' ? Colors.green : Colors.orange,
                      ),
                      title: Text('₹${history['amount'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(DateFormat('dd MMM yyyy').format(history['date'])),
                      trailing: Text(
                        history['status'],
                        style: TextStyle(
                          color: history['status'] == 'Paid' ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
