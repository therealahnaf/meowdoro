import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meowdoro/pages/app_pages/home_page.dart';
import 'package:meowdoro/pages/app_pages/collection_page.dart';
import 'package:meowdoro/pages/app_pages/shop_page.dart';
import 'package:meowdoro/pages/app_pages/profile_page.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key? key, required this.currentIndex}) : super(key: key);
  int currentIndex = 0;
  static const navigation = <NavigationDestination>[
    NavigationDestination(
      selectedIcon: Icon(
        Icons.home,
        color: Colors.orangeAccent,
      ),
      icon: Icon(
        Icons.home_outlined,
        color: Colors.white,
      ),
      label: 'Home',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.catching_pokemon,
        color: Colors.orangeAccent,
      ),
      icon: Icon(
        Icons.catching_pokemon_outlined,
        color: Colors.white,
      ),
      label: 'Collection',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.store,
        color: Colors.orangeAccent,
      ),
      icon: Icon(
        Icons.store_outlined,
        color: Colors.white,
      ),
      label: 'Shop',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.person,
        color: Colors.orangeAccent,
      ),
      icon: Icon(
        Icons.person_outlined,
        color: Colors.white,
      ),
      label: 'Profile',
    )
  ];

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int drawerIndex = 0;

  final page = [
    HomePage(),
    CollectionPage(),
    ShopPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            MainHomePage.navigation[widget.currentIndex].label),
      ),
      body: page[widget.currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.white,
          labelTextStyle: MaterialStatePropertyAll(
              TextStyle(color: Colors.white, fontSize: 11)),
        ),
        child: NavigationBar(
          animationDuration: const Duration(seconds: 1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: widget.currentIndex,
          height: 60,
          elevation: 0,
          backgroundColor: Colors.orangeAccent,
          onDestinationSelected: (int index) {
            setState(() {
              widget.currentIndex = index;
            });

            //co.updateIndex(index);
          },
          destinations: MainHomePage.navigation,
        ),
      ),
    );
  }
}
