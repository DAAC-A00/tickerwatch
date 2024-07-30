// main_screen.dart

import 'package:flutter/material.dart';
import 'package:tickerwatch/product/home/my_home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabScreens = const [
    MyHomePage(
      title: 'my home page',
    ),
    MyHomePage(
      title: 'my home page2',
    ),
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
              icon: Icon(Icons.home),
              label: 'Home2',
            ),
          ],
          selectedItemColor: currentTheme.primary,
          unselectedItemColor: currentTheme.secondary,
        ),
      ),
    );
  }
}
