import 'package:flutter/material.dart';

import 'models/Order.dart';


class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String paymentStatus;

  @override
  void initState() {
    super.initState();
    paymentStatus = widget.order.paymentStatus; // Initialize with existing status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Time:', widget.order.time),
            _buildDetailRow('Location:', widget.order.location),
            _buildDetailRow('Customer:', widget.order.customer),
            _buildDetailRow('Address:', widget.order.address),
            _buildDetailRow('Items:', widget.order.items.join(', ')),
            _buildDetailRow('Payment Status:', widget.order.paymentStatus, color: widget.order.paymentStatus == 'Paid' ? Colors.green : Colors.red,),
            const SizedBox(height: 16),
            _buildPaymentStatusDropdown(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _savePaymentStatus,
              icon: const Icon(Icons.save),
              label: const Text('Save Payment Status'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Payment Status:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: paymentStatus,
            items: ['Paid', 'Unpaid', 'Pending'].map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Paid'
                        ? Colors.green
                        : status == 'Unpaid'
                        ? Colors.red
                        : Colors.orange,
                  ),
                ),
              );
            }).toList(),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  paymentStatus = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void _savePaymentStatus() {
    // Here you can update the status in your backend or state management solution
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment status updated to "$paymentStatus"'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
