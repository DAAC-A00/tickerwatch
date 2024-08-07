// default_screen.dart

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isDialogShowing = false;

  final List<Widget> _tabScreens = const [
    HomeMainScreen(),
    PersonMainScreen(),
    SettingMainScreen(),
  ];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_isDialogShowing) {
      Navigator.of(context).pop(); // 다이얼로그 닫기
    } else {
      _showExitDialog();
    }
    return true; // 뒤로가기 버튼의 기본 동작을 막습니다.
  }

  Future<void> _showExitDialog() async {
    _isDialogShowing = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: true, // 다이얼로그 밖을 터치해도 닫히도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('앱 종료'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('앱을 종료하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그만 닫기
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫고
                SystemNavigator.pop(); // 앱 종료
              },
            ),
          ],
        );
      },
    );
    _isDialogShowing = false;
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
