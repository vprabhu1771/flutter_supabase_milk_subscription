import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {

  final String title;

  const PaymentScreen({super.key, required this.title});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Sample payment data
  final List<Map<String, dynamic>> _paymentHistory = [
    {"date": "2024-03-01", "amount": 250.00, "status": "Paid"},
    {"date": "2024-03-05", "amount": 120.00, "status": "Pending"},
    {"date": "2024-03-10", "amount": 300.00, "status": "Paid"},
    {"date": "2024-03-15", "amount": 150.00, "status": "Pending"},
  ];

  Color _getStatusColor(String status) {
    return status == "Paid" ? Colors.green : Colors.red;
  }

  void _payNow(double amount) {
    // Open Payment Gateway (Razorpay, Stripe, PayPal)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment"),
          content: Text("Pay ₹$amount using Razorpay, Stripe, or PayPal?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Proceed")),
          ],
        );
      },
    );
  }

  void _downloadInvoice(String date, double amount) {
    // Placeholder function to download invoice
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading invoice for $date (₹$amount)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text("Payment History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentHistory.length,
                itemBuilder: (context, index) {
                  final payment = _paymentHistory[index];

                  return Card(
                    child: ListTile(
                      title: Text("Date: ${payment["date"]}"),
                      subtitle: Text("Amount: ₹${payment["amount"]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (payment["status"] == "Pending")
                            IconButton(
                              icon: const Icon(Icons.payment, color: Colors.blue),
                              onPressed: () => _payNow(payment["amount"]),
                            ),
                          IconButton(
                            icon: const Icon(Icons.download, color: Colors.grey),
                            onPressed: () => _downloadInvoice(payment["date"], payment["amount"]),
                          ),
                        ],
                      ),
                      leading: Icon(Icons.circle, color: _getStatusColor(payment["status"])),
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
