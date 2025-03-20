import 'package:flutter/material.dart';
import 'package:flutter_supabase_milk_subscription/screens/ProductScreen.dart';
import 'package:flutter_supabase_milk_subscription/screens/SubscriptionScreen.dart';
import 'package:flutter_supabase_milk_subscription/screens/auth/ProfileScreen.dart';
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
  int activeSubscriptionCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchActiveSubscriptionCount();
  }

  Future<void> _fetchActiveSubscriptionCount() async {
    final response = await supabase
        .from('subscriptions')
        .select('id')
        .eq('user_id', user?.id as Object)
        .eq('status', 'active');

    setState(() {
      activeSubscriptionCount = response.length;
    });
  }

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
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(title: 'Profile')),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    user?.userMetadata?['image_path'] ?? 'https://gravatar.com/avatar/${user!.email}'),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(parentContext: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummaryCard(),
              SizedBox(height: 20),
              _buildQuickActions(),
              SizedBox(height: 20),
              _buildDailyOrderSummary(),
            ],
          ),
        ),
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
                _summaryItem("Remaining", "5 Days", Colors.orange),
                _summaryItem("Delivered", "20 Days", Colors.green),
                _summaryItem("Not Delivered", "2 Days", Colors.red),
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
        _actionButton("My Subscription", Icons.shopping_cart, Colors.blue, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubscriptionScreen(title: 'My Subscription')),
          );
        }),
        _actionButton("Track Delivery", Icons.local_shipping, Colors.green, () {
          print("Track Delivery clicked");
        }),
      ],
    );
  }

  Widget _actionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: TextStyle(color: Colors.white)),
    );
  }

  final List<Map<String, dynamic>> orders = [
    {"id": "ORD20250301", "status": "Ongoing", "delivery": "Today", "icon": Icons.shopping_bag, "color": Colors.orange},
    {"id": "ORD20250302", "status": "Delivered", "delivery": "Yesterday", "icon": Icons.shopping_bag, "color": Colors.green},
    {"id": "ORD20250303", "status": "Delivered", "delivery": "Yesterday", "icon": Icons.shopping_bag, "color": Colors.green},
    {"id": "ORD20250304", "status": "Cancelled", "delivery": "Today", "icon": Icons.shopping_bag, "color": Colors.red},
    {"id": "ORD20250305", "status": "Ongoing", "delivery": "Tomorrow", "icon": Icons.shopping_bag, "color": Colors.orange},
    {"id": "ORD20250306", "status": "Pending", "delivery": "Tomorrow", "icon": Icons.shopping_bag, "color": Colors.orange},
  ];

  Widget _buildDailyOrderSummary() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: "Yesterday"),
                      Tab(text: "Today"),
                      Tab(text: "Tomorrow"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _buildOrderList("Yesterday"),
                        _buildOrderList("Today"),
                        _buildOrderList("Tomorrow"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String day) {
    List<Map<String, dynamic>> filteredOrders = orders.where((order) => order["delivery"] == day).toList();

    if (filteredOrders.isEmpty) {
      return Center(child: Text("No orders available"));
    }

    return ListView.separated(
      itemCount: filteredOrders.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return ListTile(
          leading: Icon(order["icon"], color: order["color"]),
          title: Text("Order #${order["id"]}"),
          subtitle: Text("Expected Delivery: ${order["delivery"]}"),
          trailing: Icon(
            order["status"] == "Delivered" ? Icons.check_circle :
            order["status"] == "Cancelled" ? Icons.cancel : Icons.pending,
            color: order["status"] == "Delivered" ? Colors.green :
            order["status"] == "Cancelled" ? Colors.red : Colors.orange,
          ),
        );
      },
    );
  }
}
