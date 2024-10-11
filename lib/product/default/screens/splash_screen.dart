// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tickerwatch/product/default/checker/version_checker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String? _updateMessage;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    bool updateRequired = await VersionChecker.isUpdateRequired();
    if (updateRequired) {
      setState(() {
        _updateMessage = '스토어에서 새로운 업데이트를\n완료 후 앱을 재실행해주세요';
      });
      // 팝업 노출
      _showUpdateDialog();
    } else {
      // 기본 화면으로 이동
      _navigateToDefaultScreen();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('업데이트 알림'),
        content: Text(_updateMessage ?? '업데이트가 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _navigateToDefaultScreen() {
    context.go('/default'); // GoRouter를 사용하여 기본 화면으로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _updateMessage == null
            ? const CircularProgressIndicator()
            : Text(_updateMessage!),
      ),
    );
  }
}
