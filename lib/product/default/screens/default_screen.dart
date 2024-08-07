// default_screen.dart

import 'package:flutter/material.dart';
import 'package:tickerwatch/product/home/home_main_screen.dart';
import 'package:tickerwatch/product/setting/screens/setting_main_screen.dart';

import '../../sample_person/person_main_screen.dart';
import '../handler/device_back_button_handler.dart';

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({super.key});

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabScreens = const [
    HomeMainScreen(),
    PersonMainScreen(),
    SettingMainScreen(),
  ];

  @override
  void initState() {
    super.initState();
    DeviceBackButtonHandler.addInterceptor(context);
  }

  @override
  void dispose() {
    DeviceBackButtonHandler.removeInterceptor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _selectedTabIndex,
        children: _tabScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        selectedItemColor: currentTheme.primary,
        unselectedItemColor: currentTheme.secondary,
      ),
    );
  }
}
