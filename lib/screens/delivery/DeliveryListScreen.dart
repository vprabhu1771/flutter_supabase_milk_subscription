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
      lat: 11.7447,
      lan: 79.7588,
    ),
    Order(
      time: '09:30 AM',
      location: 'Thirupapuliyur, Cuddalore',
      customer: 'Meena Raj',
      address: '56, Lake View Road, Thirupapuliyur',
      items: ['Dosa', 'Tea'],
      paymentStatus: 'Unpaid',
      lat: 11.7425,
      lan: 79.7553,
    ),
    Order(
      time: '11:00 AM',
      location: 'Semmandalam, Cuddalore',
      customer: 'Karthik Subramanian',
      address: '12, Gandhi Nagar, Semmandalam',
      items: ['Poori', 'Sambar', 'Juice'],
      paymentStatus: 'Paid',
      lat: 11.7436,
      lan: 79.7601,
    ),
    Order(
      time: '01:00 PM',
      location: 'OTC, Cuddalore',
      customer: 'Revathi N',
      address: '88, Market Road, Old Town Cuddalore (OTC)',
      items: ['Meals', 'Buttermilk'],
      paymentStatus: 'Paid',
      lat: 11.7384,
      lan: 79.7632,
    ),
    Order(
      time: '03:30 PM',
      location: 'Vallalar Nagar, Cuddalore',
      customer: 'Suresh Babu',
      address: '45, Vallalar Street, Vallalar Nagar',
      items: ['Chapathi', 'Paneer Curry'],
      paymentStatus: 'Unpaid',
      lat: 11.7419,
      lan: 79.7504,
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
          return _buildDeliveryCard(delivery, context);
        },
      ),
    );
  }

  Widget _buildDeliveryCard(Order delivery, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigate to OrderDetailScreen and pass the order
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrderDetailScreen(order: delivery),
          //   ),
          // );

          // Navigate to OrderDetailScreen and pass the order
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryMapScreen(order: delivery),
            ),
          );
        },
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
                  _buildDetailRow(
                    'Payment Status:',
                    delivery.paymentStatus,
                    color: delivery.paymentStatus == 'Paid' ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
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
