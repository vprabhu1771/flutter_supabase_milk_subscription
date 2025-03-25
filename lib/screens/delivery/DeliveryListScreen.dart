import 'package:flutter/material.dart';
import 'DeliveryMapScreen.dart';
import 'OrderDetailScreen.dart';
import 'models/Order.dart';

class DeliveryListScreen extends StatefulWidget {
  final String title;

  const DeliveryListScreen({super.key, required this.title});

  @override
  State<DeliveryListScreen> createState() => _DeliveryListScreenState();
}

class _DeliveryListScreenState extends State<DeliveryListScreen> {
  final List<Order> deliveries = [
    Order(
      time: '08:00 AM',
      location: 'Manjakuppam, Cuddalore',
      customer: 'Arun Kumar',
      address: '23, Main Street, Manjakuppam',
      items: ['Idli', 'Vada', 'Coffee'],
      paymentStatus: 'Paid',
      deliveryStatus: 'Pending',
      lat: 11.7447,
      lng: 79.7588,
    ),
    Order(
      time: '09:30 AM',
      location: 'Thirupapuliyur, Cuddalore',
      customer: 'Meena Raj',
      address: '56, Lake View Road, Thirupapuliyur',
      items: ['Dosa', 'Tea'],
      paymentStatus: 'Unpaid',
      deliveryStatus: 'Pending',
      lat: 11.7425,
      lng: 79.7553,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    deliveries.sort((a, b) => a.time.compareTo(b.time)); // Sort by time

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          return _buildDeliveryCard(delivery, index, context);
        },
      ),
    );
  }

  Widget _buildDeliveryCard(Order delivery, int index, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          child: const Icon(Icons.location_on, color: Colors.blueAccent),
        ),
        title: Text(
          delivery.location,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Time: ${delivery.time}'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Customer:', delivery.customer),
                _buildDetailRow('Address:', delivery.address),
                _buildDetailRow('Items:', delivery.items.join(', ')),
                // _buildDetailRow(
                //   'Payment Status:',
                //   delivery.paymentStatus,
                //   color: delivery.paymentStatus == 'Paid' ? Colors.green : Colors.red,
                // ),
                _buildDetailRow(
                  'Delivery Status:',
                  delivery.deliveryStatus ?? 'Pending',
                  color: delivery.deliveryStatus == 'Delivered' ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (deliveries[index].deliveryStatus == 'Pending') {
                            deliveries[index].deliveryStatus = 'Delivered';
                          } else {
                            deliveries[index].deliveryStatus = 'Pending';
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deliveries[index].deliveryStatus == 'Delivered'
                            ? Colors.red // Red when Delivered (Undo)
                            : Colors.green, // Green when Pending (Mark Delivered)
                      ),
                      child: Text(
                        deliveries[index].deliveryStatus == 'Delivered'
                            ? 'Pending' // Show Undo when Delivered
                            : 'Mark Delivered', // Show Mark Delivered when Pending
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryMapScreen(order: delivery),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('View on Map'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
}
