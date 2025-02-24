import 'package:flutter/material.dart';
import 'package:flutter_supabase_milk_subscription/widgets/CustomDrawer.dart';

class DeliveryDashboard extends StatefulWidget {

  final String title;

  const DeliveryDashboard({super.key, required this.title});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(parentContext: context),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}
