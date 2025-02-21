import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/SubscriptionPlan.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final String title;

  const SubscriptionPlanScreen({super.key, required this.title});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late List<SubscriptionPlan> subscriptionPlans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    setState(() => isLoading = true);

    try {
      final response = await supabase.from('subscription_plans').select();

      print(response.toString());

      setState(() {
        subscriptionPlans = (response as List)
            .map((json) => SubscriptionPlan.fromJson(json))
            .toList();
      });
    } catch (e) {
      print('Error fetching subscription plans: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onRefresh() async {
    await fetchSubscriptionPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : subscriptionPlans.isEmpty
            ? const Center(child: Text('No subscription plans available.'))
            : ListView.builder(
          itemCount: subscriptionPlans.length,
          itemBuilder: (context, index) {
            final plan = subscriptionPlans[index];
            return ListTile(
              title: Text(plan.name),
              onTap: () {

              },
            );
          },
        ),
      ),
    );
  }
}
