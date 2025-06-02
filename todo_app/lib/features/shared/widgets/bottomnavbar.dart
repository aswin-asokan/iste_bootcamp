import 'package:flutter/material.dart';
import 'package:todo_app/features/home/screens/home.dart';
import 'package:todo_app/features/settings/screens/settings.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int selectedIndex = 0;
  final List<Widget> pages = [Home(), const Settings()];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black87,
        labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white)),
        indicatorColor: Colors.white,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
      ),
    );
  }
}
