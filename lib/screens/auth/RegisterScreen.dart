import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../admin/AdminDashboard.dart';
import '../../delivery/DeliveryDashboard.dart';
import '../HomeScreen.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  final String title;

  const RegisterScreen({super.key, required this.title});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  final TextEditingController nameController = TextEditingController(text: "prabhu");
  final TextEditingController phoneController = TextEditingController(text: "9944177142");
  final TextEditingController emailController = TextEditingController(text: "prabhu@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "admin@123");

  bool _isLoading = false;
  bool _obscureText = true;

  Map<String, dynamic>? _selectedRole = {'key': 'customer', 'value': 'Customer'};

  final List<Map<String, dynamic>> roles = [
    {'key': 'customer', 'value': 'Customer'},
    {'key': 'delivery', 'value': 'Delivery'},
    {'key': 'admin', 'value': 'Admin'},
  ];

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final signUpResponse = await _supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
        },
      );

      if (signUpResponse.user != null) {
        Fluttertoast.showToast(msg: "Registration Successful!");
        await _signIn();
      } else {
        Fluttertoast.showToast(msg: "Registration failed.");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.session != null) {
        await storage.write(key: 'session', value: response.session!.accessToken);
        Fluttertoast.showToast(msg: "Login successful!");

        final userId = response.user?.id;
        if (userId != null) {
          await _assignUserRole(userId);
        }
      } else {
        Fluttertoast.showToast(msg: "Login failed. Please try again.");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Login failed: $error");
    }
  }

  Future<void> _assignUserRole(String userId) async {
    try {
      final roleResponse = await _supabase
          .from('roles')
          .select()
          .eq('name', _selectedRole?['key'])
          .single();

      if (roleResponse != null) {
        final roleId = roleResponse['id'];
        final roleName = roleResponse['name'];

        final insertResponse = await _supabase
            .from('user_roles')
            .insert({'user_id': userId, 'role_id': roleId})
            .select()
            .single();

        if (insertResponse != null) {
          Fluttertoast.showToast(msg: "Role assigned: $roleName");
          _navigateBasedOnRole(roleName);
        } else {
          Fluttertoast.showToast(msg: "Failed to assign role.");
        }
      } else {
        Fluttertoast.showToast(msg: "Role not found.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error assigning role: $e");
    }
  }

  void _navigateBasedOnRole(String role) {
    Widget screen;
    switch (role) {
      case 'admin':
        screen = AdminDashboard(title: "Admin Dashboard");
        break;
      case 'delivery':
        screen = DeliveryDashboard(title: "Delivery Dashboard");
        break;
      default:
        screen = HomeScreen(title: 'Home');
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: nameController,
                label: 'Full Name',
                validator: (value) => value!.isEmpty ? 'Enter a valid Full Name' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Enter a valid Phone' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: passwordController,
                label: 'Password',
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
                validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: roles.firstWhere(
                      (role) => role['key'] == _selectedRole?['key'],
                  orElse: () => roles[0],
                ),
                decoration: const InputDecoration(labelText: 'Select Role'),
                items: roles.map((role) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: role,
                    child: Text(role['value']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null ? 'Please select a role' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _signUp,
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen(title: 'Login')),
                ),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
