// custom_modal_bottom_sheet.dart

import 'package:flutter/material.dart';

void showCustomModalBottomSheet(
    BuildContext context, List<String> contentList) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      final currentTextTheme = Theme.of(context).textTheme;
      final double bodySmall = currentTextTheme.bodySmall?.fontSize ?? 20;
      final double paddingSize = bodySmall * 2;
      final double titleSize = currentTextTheme.titleMedium?.fontSize ?? 22;
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
                    'ℹ️ 유의사항',
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
                height: paddingSize,
              ),
              ..._buildContent(contentList),
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
        contentList[index],
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      // 짝수 인덱스는 내용
      return Text('${contentList[index]}\n');
    }
  });
}
