// custom_select_modal_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:tickerwatch/product/default/handler/device_back_button_handler.dart';

Future<void> showCustomSelectModalBottomSheet(
    BuildContext context,
    String title,
    List<int> values, // int 값 리스트로 변경
    Function(int) onValueSelected, // 선택된 값을 처리할 콜백 추가
    {bool isTmpBackButtonDisable = false}) async {
  if (isTmpBackButtonDisable) {
    DeviceBackButtonHandler.disable();
  }

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      final currentTextTheme = Theme.of(context).textTheme;
      final double titleSize = currentTextTheme.titleMedium?.fontSize ?? 22;
      final double bodySmall = currentTextTheme.bodySmall?.fontSize ?? 20;
      final double paddingSize = bodySmall * 2;
      return Padding(
        padding: EdgeInsets.all(paddingSize),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: titleSize),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // 바텀 시트를 닫기
                    },
                  ),
                ],
              ),
              SizedBox(height: bodySmall),
              ...values.map((value) => ListTile(
                    title: Text('${(value / 1000)} s'),
                    onTap: () {
                      onValueSelected(value); // 선택된 값 처리
                      Navigator.of(context).pop(); // 바텀 시트 닫기
                    },
                  )),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    if (isTmpBackButtonDisable) {
      DeviceBackButtonHandler.enable();
    }
  });
}
