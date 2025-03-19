import 'package:flutter/material.dart';

class AdminNotificationScreen extends StatefulWidget {

  final String title;

  const AdminNotificationScreen({super.key, required this.title});

  @override
  State<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
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
          const SectionHeader(title: 'Customer Notifications'),
          NotificationCard(
            icon: Icons.payment,
            title: 'Pending Payment',
            subtitle: 'Your payment for Order #5678 is overdue.',
            time: '5 mins ago',
          ),
          NotificationCard(
            icon: Icons.attach_money,
            title: 'Payment Reminder',
            subtitle: 'You have an unpaid invoice of ₹1200.',
            time: '1 hour ago',
          ),
          const SectionHeader(title: 'Delivery Personnel Alerts'),
          NotificationCard(
            icon: Icons.local_shipping,
            title: 'Order Assigned',
            subtitle: 'You have a new delivery task: Order #9876.',
            time: '15 mins ago',
          ),
          NotificationCard(
            icon: Icons.update,
            title: 'Order Details Changed',
            subtitle: 'Order #1234 has been updated.',
            time: '2 hours ago',
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
