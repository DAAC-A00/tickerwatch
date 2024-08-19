// default_screen.dart

import 'package:flutter/material.dart';
import 'package:tickerwatch/product/counter/counter_main_screen.dart';
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
      body: _getBodyWidget(_selectedTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.onetwothree),
            label: 'Counter',
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

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return const CounterMainScreen();
      case 1:
        return const PersonMainScreen();
      case 2:
        return const SettingMainScreen();
      default:
        return const CounterMainScreen();
    }
  }
}
