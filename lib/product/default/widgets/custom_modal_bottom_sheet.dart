// custom_modal_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:tickerwatch/product/default/handler/device_back_button_handler.dart';

void showCustomModalBottomSheet(
    BuildContext context, String title, List<String> contentList) {
  DeviceBackButtonHandler
      .disable(); // bottomSheet가 main화면에서 나타나면 뒤로가기 물리 버튼을 비활성화

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      final currentTextTheme = Theme.of(context).textTheme;
      final double titleSize = currentTextTheme.titleMedium?.fontSize ?? 22;
      final double bodySmall = currentTextTheme.bodySmall?.fontSize ?? 20;
      final double paddingSize = bodySmall * 2;
      return Padding(
        padding: EdgeInsets.only(
          top: paddingSize,
          bottom: paddingSize,
          left: paddingSize,
          right: paddingSize,
        ),
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
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // 바텀 시트를 닫기
                    },
                  ),
                ],
              ),
              SizedBox(
                height: bodySmall,
              ),
              ..._buildContent(contentList, bodySmall),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    DeviceBackButtonHandler
        .enable(); // bottomSheet가 main화면에서 사라지면 뒤로가기 물리 버튼을 활성화
  });
}

// content 리스트를 받아서 Text 위젯으로 변환하는 메서드
List<Widget> _buildContent(List<String> contentList, double bodySmall) {
  return List<Widget>.generate(contentList.length, (index) {
    if (index % 2 == 0) {
      // 홀수 인덱스는 제목
      return Text(
        contentList[index],
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      // 짝수 인덱스는 내용
      return Column(
        children: [
          Text(contentList[index]),
          SizedBox(height: bodySmall), // SizedBox 추가
        ],
      );
    }
  });
}
