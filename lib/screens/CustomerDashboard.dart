import 'package:flutter/material.dart';
import 'package:flutter_supabase_milk_subscription/screens/ProductScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/CustomDrawer.dart';
import 'CustomerNotificationScreen.dart';

final supabase = Supabase.instance.client;

class CustomerDashboard extends StatefulWidget {
  final String title;

  const CustomerDashboard({super.key, required this.title});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {

  var user = supabase.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerNotificationScreen(title: 'Notification')),
              );
            }, // Notification logic
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  user?.userMetadata?['image_path'] ?? 'https://gravatar.com/avatar/${user!.email}'),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(parentContext: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummaryCard(),
            SizedBox(height: 20),
            _buildQuickActions(),
            SizedBox(height: 20),
            Expanded(child: _buildOrderList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen(title: 'Product')),
          );
        }, // Navigate to Order Placement
        icon: Icon(Icons.add_shopping_cart),
        label: Text("Place Order"),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Active Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem("Ongoing", "5", Colors.orange),
                _summaryItem("Delivered", "20", Colors.green),
                _summaryItem("Cancelled", "2", Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String count, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4),
        Text(title),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton("Place Order", Icons.shopping_cart, Colors.blue),
        _actionButton("Track Delivery", Icons.local_shipping, Colors.green),
      ],
    );
  }

  Widget _actionButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildOrderList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.shopping_bag, color: Colors.blue),
          title: Text("Order #${index + 1}"),
          subtitle: Text("Expected Delivery: Tomorrow"),
          trailing: Icon(Icons.check_circle, color: Colors.green),
        );
      },
    );
  }
}
