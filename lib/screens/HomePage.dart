import 'package:flutter/material.dart';


import 'HomeScreen.dart';
import 'ProductScreen.dart';
import 'auth/ProfileScreen.dart';
import 'CartScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ProductScreen(title: 'Products'),
    CartScreen(title: 'Cart'),
    ProfileScreen(title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        // selectedItemColor: Colors.blue, // Highlight selected item
        // unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart_outlined), // Fixed icon name
          //   label: 'Cart',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Simplified user icon
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
