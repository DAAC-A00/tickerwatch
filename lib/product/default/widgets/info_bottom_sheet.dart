// info_bottom_sheet.dart

import 'package:flutter/material.dart';

void showInfoBottomSheet(BuildContext context, List<String> contentList) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      final double paddingSize =
          Theme.of(context).textTheme.bodySmall?.fontSize ?? 20;
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: paddingSize,
          horizontal: paddingSize * 2,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildContent(contentList),
              const Text(''),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 바텀 시트를 닫기
                },
                child: const Text('닫기'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// content 리스트를 받아서 Text 위젯으로 변환하는 메서드
List<Widget> _buildContent(List<String> contentList) {
  return List<Widget>.generate(contentList.length, (index) {
    if (index % 2 == 0) {
      // 홀수 인덱스는 제목
      return Text(
        '\n${contentList[index]}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      // 짝수 인덱스는 내용
      return Text(contentList[index]);
    }
  });
}
