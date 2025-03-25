import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {

  final String title;

  const NotificationScreen({super.key, required this.title});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SectionHeader(title: 'New Delivery Assignments'),
          NotificationCard(
            icon: Icons.local_shipping,
            title: 'New delivery assigned',
            subtitle: 'Order #1234 has been assigned to you.',
            time: '2 mins ago',
          ),
          NotificationCard(
            icon: Icons.location_on,
            title: 'Delivery location updated',
            subtitle: 'Order #5678 has a new pickup location.',
            time: '10 mins ago',
          ),
          // const SectionHeader(title: 'Payment Reminders'),
          // NotificationCard(
          //   icon: Icons.attach_money,
          //   title: 'Payment pending',
          //   subtitle: 'Order #2345 payment is due today.',
          //   time: '30 mins ago',
          // ),
          // NotificationCard(
          //   icon: Icons.credit_card,
          //   title: 'Payment received',
          //   subtitle: 'Order #6789 payment has been processed.',
          //   time: '1 hour ago',
          // ),
          const SectionHeader(title: 'Order Updates'),
          NotificationCard(
            icon: Icons.inventory_2,
            title: 'Order Delivered',
            subtitle: 'Order #3456 is out for delivery.',
            time: '3 hours ago',
          ),
          NotificationCard(
            icon: Icons.check_circle,
            title: 'Order pending',
            subtitle: 'Order #7890 has been delivered.',
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}