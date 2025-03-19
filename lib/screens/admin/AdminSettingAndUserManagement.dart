import 'package:flutter/material.dart';

class AdminSettingAndUserManagement extends StatefulWidget {

  final String title;

  const AdminSettingAndUserManagement({super.key, required this.title});

  @override
  State<AdminSettingAndUserManagement> createState() => _AdminSettingAndUserManagementState();
}

class _AdminSettingAndUserManagementState extends State<AdminSettingAndUserManagement> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & User Management'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SectionHeader(title: 'Admin Account Settings'),
          SettingsTile(
            icon: Icons.person,
            title: 'Edit Profile',
            subtitle: 'Update your name, email, and password',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.security,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {},
          ),
          const SectionHeader(title: 'Delivery Personnel Management'),
          SettingsTile(
            icon: Icons.group_add,
            title: 'Add New Delivery Personnel',
            subtitle: 'Create accounts and assign roles',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.manage_accounts,
            title: 'Manage Roles & Permissions',
            subtitle: 'Assign delivery & admin roles',
            onTap: () {},
          ),
          const SectionHeader(title: 'Payment Gateway Settings'),
          SettingsTile(
            icon: Icons.payment,
            title: 'Configure Payment Gateway',
            subtitle: 'Setup Stripe, PayPal, or Razorpay',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.attach_money,
            title: 'Transaction History',
            subtitle: 'View all payments and transactions',
            onTap: () {},
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

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
