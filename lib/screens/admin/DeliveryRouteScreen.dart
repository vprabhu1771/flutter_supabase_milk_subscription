import 'package:flutter/material.dart';

import 'LiveTrackingScreen.dart';

class DeliveryRouteScreen extends StatefulWidget {
  final String title;

  const DeliveryRouteScreen({super.key, required this.title});

  @override
  State<DeliveryRouteScreen> createState() => _DeliveryRouteScreenState();
}

class _DeliveryRouteScreenState extends State<DeliveryRouteScreen> {

  final List<Map<String, String>> deliveryRoutes = [
    {"name": "John Doe", "route": "Route A", "status": "On the way"},
    {"name": "Jane Smith", "route": "Route B", "status": "Delivered"},
    {"name": "Mike Johnson", "route": "Route C", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delivery Routes")),
      body: ListView.builder(
        itemCount: deliveryRoutes.length,
        itemBuilder: (context, index) {
          var route = deliveryRoutes[index];
          return Card(
            child: ListTile(
              title: Text("${route['name']}"),
              subtitle: Text("Route: ${route['route']}"),
              trailing: Text(route['status']!, style: TextStyle(color: Colors.green)),
              onTap: () {
                // Navigate to live tracking
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => LiveTrackingScreen(),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}