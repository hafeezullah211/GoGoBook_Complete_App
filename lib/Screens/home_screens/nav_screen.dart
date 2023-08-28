import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogobook/Screens/home_screens/profile_screen.dart';
import 'package:gogobook/Screens/home_screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../../theme_changer.dart';
import 'home_page_screen.dart';

class HomeScreen3 extends StatefulWidget {
  final Function onLogout; // Add this line

  HomeScreen3({required this.onLogout}); // Add this constructor
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen3> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
      return MaterialApp(
        title: 'Nav Screen',
        theme: themeChanger.currentTheme,
        home: Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: themeChanger.getBottomNavBarColor(),
            // Set the color of selected icons and text
            selectedItemColor: Color(0xFFfab313),
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora'
            ),
            unselectedItemColor: Colors.white,
            selectedFontSize: 18,
            unselectedFontSize: 14,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'navHome'.tr,

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'navSearch'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'navProfile'.tr,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      );
    });
  }
}