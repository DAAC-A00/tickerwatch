// default_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/home/screens/home_main_screen.dart';
import 'package:tickerwatch/product/setting/screens/setting_main_screen.dart';
import 'package:tickerwatch/product/tickeralarm/screens/ticker_alarm_main_screen.dart';

import '../../admin/screens/admin_main_screen.dart';
import '../../setting/states/common_setting_provider.dart';
import '../handler/device_back_button_handler.dart';

class DefaultScreen extends ConsumerStatefulWidget {
  const DefaultScreen({super.key});

  @override
  ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends ConsumerState<DefaultScreen> {
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
    final commonSetting = ref.watch(commonSettingProvider);

    return Scaffold(
      body: _getBodyWidget(_selectedTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: _buildBottomNavigationBarItems(commonSetting.isAdminMode),
        selectedItemColor: currentTheme.primary,
        unselectedItemColor: currentTheme.secondary,
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(
      bool isAdminMode) {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.alarm),
        label: 'Alarm',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Setting',
      ),
      if (isAdminMode)
        const BottomNavigationBarItem(
          icon: Icon(Icons.devices),
          label: 'Admin',
        ),
    ];
  }

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return const HomeMainScreen();
      case 1:
        return const TickerAlarmMainScreen();
      case 2:
        return const SettingMainScreen();
      case 3:
        return const AdminMainScreen();
      default:
        return const HomeMainScreen();
    }
  }
}
