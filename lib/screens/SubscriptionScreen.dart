import 'package:flutter/material.dart';
import 'package:flutter_supabase_milk_subscription/screens/ProductScreen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String title;

  const SubscriptionScreen({super.key, required this.title});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<Map<String, String>> subscriptions = []; // Empty list to test UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: subscriptions.isEmpty ? _buildNoSubscriptionUI() : _buildSubscriptionList(),
    );
  }

  Widget _buildNoSubscriptionUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.subscriptions, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "You're not subscribed to any plan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          const Text(
            "Subscribe to a plan and start receiving your orders hassle-free.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle subscribe action
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(title: 'Products')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Subscribe Now", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = subscriptions[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text(subscription["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Status: ${subscription["status"]}"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        );
      },
    );
  }
}
