import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends StatefulWidget {

  final String title;

  const SubscriptionScreen({super.key, required this.title});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  String selectedPlan = "Daily";

  // Sample subscription data
  final Map<int, List<Map<String, String>>> _subscriptions = {
    1: [{"product": "Milk (1L)", "status": "Delivered"}],
    3: [{"product": "Milk (2L)", "status": "Upcoming"}],
    5: [{"product": "Curd (500g)", "status": "Delivered"}],
    10: [{"product": "Butter (250g)", "status": "Cancelled"}],
  };

  Color _getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Upcoming":
        return Colors.blue;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _modifySubscription(int day) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modify Subscription"),
          content: const Text("Would you like to modify or cancel your subscription?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _subscriptions.remove(day);
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel Subscription", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Modify logic
              },
              child: const Text("Modify", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Subscription Plan Selector
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedPlan,
              items: ["Daily", "Weekly", "Custom"].map((plan) {
                return DropdownMenuItem(value: plan, child: Text(plan));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlan = value!;
                });
              },
            ),
          ),

          // Scrollable Subscription Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 50,
                  columns: const [
                    DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List.generate(daysInMonth, (index) {
                    int day = index + 1;
                    List<Map<String, String>> orders = _subscriptions[day] ?? [];

                    return DataRow(
                      cells: [
                        DataCell(Text("$day ${DateFormat('MMM').format(_currentMonth)}")),
                        DataCell(
                          orders.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orders.map((order) => Text(order["product"]!)).toList(),
                          )
                              : const Text("-"),
                        ),
                        DataCell(
                          orders.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orders
                                .map((order) => Text(
                              order["status"]!,
                              style: TextStyle(color: _getStatusColor(order["status"]!)),
                            ))
                                .toList(),
                          )
                              : const Text("-"),
                        ),
                        DataCell(
                          orders.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _modifySubscription(day),
                          )
                              : const Text("-"),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
