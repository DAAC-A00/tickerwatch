// default_screen.dart

import 'package:flutter/material.dart';
import 'package:tickerwatch/product/home/home_main_screen.dart';
import 'package:tickerwatch/product/setting/screens/setting_main_screen.dart';

import '../../sample_person/person_main_screen.dart';

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

  // 앱 종료 직전 확인 팝업 노출
  Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('앱을 종료하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                child: const Text('아니요'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: const Text('예'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        return _showExitPopup(context);
      },
      child: Scaffold(
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
      ),
    );
  }
}
