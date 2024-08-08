// device_back_button_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class DeviceBackButtonHandler {
  static bool _isDialogShowing = false;
  static bool _isEnable = true;

  static void addInterceptor(BuildContext context) {
    BackButtonInterceptor.add((bool stopDefaultButtonEvent, RouteInfo info) {
      if (!_isEnable) {
        return false; // 비활성화된 경우 기본 동작을 실행합니다.
      }

      if (_isDialogShowing) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
      } else {
        _showExitDialog(context);
      }
      return true; // 뒤로가기 버튼의 기본 동작을 막습니다.
    });
  }

  static void removeInterceptor() {
    BackButtonInterceptor.remove((bool stopDefaultButtonEvent, RouteInfo info) {
      return true;
    });
  }

  static Future<void> _showExitDialog(BuildContext context) async {
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

  static void enable() {
    _isEnable = true;
  }

  static void disable() {
    _isEnable = false;
  }
}
