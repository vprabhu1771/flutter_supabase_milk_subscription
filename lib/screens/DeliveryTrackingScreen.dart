import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  final String title;

  const DeliveryTrackingScreen({super.key, required this.title});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  final DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  // Sample subscription orders mapped by date
  final Map<int, List<Map<String, String>>> _ordersByDate = {
    1: [{"product": "Milk (1L)", "status": "Delivered"}],
    3: [{"product": "Milk (2L)", "status": "Not Delivered"}],
    5: [{"product": "Curd (500g)", "status": "Delivered"}],
    10: [{"product": "Butter (250g)", "status": "Not Delivered"}],
    15: [{"product": "Milk (1L)", "status": "Delivered"}],
    20: [{"product": "Milk (2L)", "status": "Not Delivered"}],
    25: [{"product": "Paneer (200g)", "status": "Delivered"}],
  };

  Color _getStatusColor(String status) {
    return status == "Delivered" ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 50,
              columns: const [
                DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(daysInMonth, (index) {
                int day = index + 1;
                List<Map<String, String>> orders = _ordersByDate[day] ?? [];

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
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
