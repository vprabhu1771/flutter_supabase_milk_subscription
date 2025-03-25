import 'package:flutter/material.dart';


import 'package:flutter_supabase_milk_subscription/screens/CartScreen.dart';
import 'package:flutter_supabase_milk_subscription/screens/CustomerDashboard.dart';
import 'package:flutter_supabase_milk_subscription/screens/HomePage.dart';
import 'package:flutter_supabase_milk_subscription/screens/DeliveryTrackingScreen.dart';
import 'package:flutter_supabase_milk_subscription/screens/PaymentScreen.dart';
import 'package:flutter_supabase_milk_subscription/screens/ProductScreen.dart';
import 'package:flutter_supabase_milk_subscription/screens/SettingScreen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../screens/SubscriptionScreen.dart';
import '../screens/admin/AdminDashboard.dart';
import '../screens/admin/AdminNotificationScreen.dart';
import '../screens/admin/AdminSettingAndUserManagement.dart';
import '../screens/admin/AnalyticsReportScreen.dart';
import '../screens/admin/DeliveryRouteScreen.dart';
import '../screens/admin/order/OrderManagementScreen.dart';
import '../screens/admin/PaymentTrackingScreen.dart';
import '../screens/admin/customer/CustomerManagementScreen.dart';
import '../screens/auth/LoginScreen.dart';
import '../screens/auth/ProfileScreen.dart';
import '../screens/auth/RegisterScreen.dart';
import '../screens/delivery/DeliveryDashboard.dart';
import '../screens/delivery/DeliveryListScreen.dart';
import '../screens/delivery/EarningsPaymentsScreen.dart';
import '../screens/delivery/NotificationScreen.dart';

class CustomDrawer extends StatelessWidget {
  final BuildContext parentContext;

  CustomDrawer({required this.parentContext});

  final supabase = Supabase.instance.client;
  final storage = FlutterSecureStorage();

  Future<void> signOut() async {
    await supabase.auth.signOut();
    await storage.delete(key: 'session');
    Navigator.pushReplacement(
      parentContext,
      MaterialPageRoute(builder: (context) => LoginScreen(title: 'Login')),
    );
  }

  Future<String?> getUserRole() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await supabase
        .from('user_roles')
        .select('roles(id, name)')
        .eq('user_id', userId)
        .maybeSingle();

    return response != null ? response['roles']['name'] as String? : null;
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Drawer(
      child: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          final role = snapshot.data;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.userMetadata?['name'] ?? "Guest"),
                accountEmail: Text(user?.email ?? "No Email"),
                currentAccountPicture: CircleAvatar(
                  // child: Icon(Icons.person, size: 40),
                  backgroundImage: NetworkImage(user?.userMetadata?['image_path'] ?? 'https://gravatar.com/avatar/${user!.email}'),
                ),
              ),

              // Common for all logged-in users
              if (user != null) ...[
                // ListTile(
                //   leading: Icon(Icons.home),
                //   title: Text('Home'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => HomePage()));
                //   },
                // ),
              ],

              // Role-based rendering
              if (role == 'admin') ...[
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => AdminDashboard(title: 'Admin Dashboard')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Customers Management'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        parentContext,
                        MaterialPageRoute(builder: (context) => CustomerManagementScreen(title: 'Customers Management'))
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Order Management'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        parentContext,
                        MaterialPageRoute(builder: (context) => OrderManagementScreen(title: 'Order Management'))
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('Payment Tracking'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        parentContext,
                        MaterialPageRoute(builder: (context) => PaymentTrackingScreen(title: 'Payment Tracking'))
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.delivery_dining),
                //   title: Text('Delivery Routes & Tracking'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         parentContext,
                //         MaterialPageRoute(builder: (context) => DeliveryRouteScreen(title: 'Delivery Routes & Tracking'))
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.analytics_outlined),
                  title: Text('Analytics & Reports'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        parentContext,
                        MaterialPageRoute(builder: (context) => AnalyticsReportScreen(title: 'Analytics & Reports'))
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.notification_important),
                //   title: Text('Notifications & Alerts'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         parentContext,
                //         MaterialPageRoute(builder: (context) => AdminNotificationScreen(title: 'Notifications & Alerts'))
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings & User Management'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => AdminSettingAndUserManagement(title: 'Settings & User Management')));
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.settings),
                //   title: Text('Settings'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => SettingScreen(title: 'Settings')));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => ProfileScreen(title: 'Profile')));
                  },
                ),
              ] else if (role == 'customer') ...[
                // ListTile(
                //   leading: Icon(Icons.home),
                //   title: Text('Home'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => HomePage()));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => CustomerDashboard(title: 'Customer Dashboard')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Products'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => ProductScreen(title: 'Product')));
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.shopping_cart_checkout),
                //   title: Text('Cart'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => CartScreen(title: 'Cart')));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_checkout),
                  title: Text('Delivery Tracking'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => DeliveryTrackingScreen(title: 'Delivery Tracking')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_checkout),
                  title: Text('Milk Subscription'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => SubscriptionScreen(title: 'Milk Subscription')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_checkout),
                  title: Text("Payments & Billing"),
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(parentContext, MaterialPageRoute(builder: (context) => PaymentScreen(title: "Payments & Billing")));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => SettingScreen(title: 'Settings')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => ProfileScreen(title: 'Profile')));
                  },
                ),
              ] else if (role == 'delivery') ...[
                // ListTile(
                //   leading: Icon(Icons.home),
                //   title: Text('Home'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => DeliveryDashboard(title: 'Delivery Dashboard')));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => DeliveryDashboard(title: 'Dashboard')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('Assigned Deliveries'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => DeliveryListScreen(title: 'Assigned Deliveries')));
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.monetization_on),
                //   title: Text('Earnings & Payments'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => EarningsPaymentsScreen(title: 'Earnings & Payments')));
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.notifications),
                //   title: Text('Notification'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => NotificationScreen(title: 'Notification')));
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.map),
                //   title: Text('Order'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => DeliveryMapScreen()));
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.map),
                //   title: Text('Map'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(parentContext, MaterialPageRoute(builder: (context) => DeliveryMapScreen()));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => ProfileScreen(title: 'Profile')));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, MaterialPageRoute(builder: (context) => SettingScreen(title: 'Settings')));
                  },
                ),
              ],

              // Logout option for authenticated users
              if (user != null) ...[
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: signOut,
                ),
              ] else ...[
                // Guest users: Login & Register
                ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.pushReplacement(
                      parentContext,
                      MaterialPageRoute(builder: (context) => LoginScreen(title: 'Login')),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.app_registration),
                  title: Text('Register'),
                  onTap: () {
                    Navigator.pushReplacement(
                      parentContext,
                      MaterialPageRoute(builder: (context) => RegisterScreen(title: 'Register')),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
