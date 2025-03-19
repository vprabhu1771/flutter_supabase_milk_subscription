import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/CustomDrawer.dart';
import '../CustomerDashboard.dart';

final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = supabase.auth.currentUser;

  final storage = FlutterSecureStorage(); // Secure storage instance

  Future<void> signOut() async {
    await supabase.auth.signOut();
    await storage.delete(key: 'session');

    // Navigate to login screen and remove all previous routes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // builder: (context) => LoginScreen(title: 'Login'),
        builder: (context) => CustomerDashboard(title: 'Home'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: CustomDrawer(parentContext: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image View
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://gravatar.com/avatar/${user!.email}'), // Replace with the user's image URL
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),

              // Profile Details List
              ListTile(
                leading: Icon(Icons.person),
                title: Text(user?.userMetadata?['name']), // Replace with dynamic user name
                trailing: Icon(Icons.edit),
                onTap: () {
                  // Handle the edit profile action
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.email),
                title: Text(user!.email ?? ""), // Replace with dynamic user name
                // trailing: Icon(Icons.edit),
                onTap: () {
                  // Handle the edit profile action
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.phone),
                title: Text(user?.userMetadata?['phone']), // Replace with dynamic phone number
                onTap: () {
                  // Handle phone number action
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('New York, USA'), // Replace with dynamic address
                onTap: () {
                  // Handle address action
                },
              ),
              const Divider(),

              // Logout Button (Red color)
              TextButton(
                onPressed: () {

                  signOut();

                  // Handle logout action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out')),
                  );

                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}