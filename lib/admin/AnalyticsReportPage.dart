import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For charts

class AnalyticsReportScreen extends StatefulWidget {
  
  final String title;

  const AnalyticsReportScreen({super.key, required this.title});
  
  @override
  _AnalyticsReportScreenState createState() => _AnalyticsReportScreenState();
}

class _AnalyticsReportScreenState extends State<AnalyticsReportScreen> {
  String selectedReport = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics & Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report type selection (daily, weekly, monthly)
            DropdownButton<String>(
              value: selectedReport,
              onChanged: (String? newValue) {
                setState(() {
                  selectedReport = newValue!;
                });
              },
              items: <String>['Daily', 'Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Sales & Deliveries Trend Graph
            Text('Sales & Deliveries Trend', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 1),
                        FlSpot(3, 4),
                        FlSpot(4, 2),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Sales and Deliveries Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Sales', style: TextStyle(fontSize: 16)),
                    Text('Total Deliveries', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$1500', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('120 Deliveries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            // Export Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add PDF export functionality here
                },
                child: Text('Export Report as PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
