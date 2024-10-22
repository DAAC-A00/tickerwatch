// card_list_screen.dart

import 'package:flutter/material.dart'; // Flutter의 Material Design 라이브러리를 가져옵니다.

class CardListScreen extends StatelessWidget {
  // 카드에 표시할 데이터 리스트를 정의합니다.
  final List<Map<String, String>> items = [
    {'title': 'Card 1', 'description': 'This is the description for Card 1'},
    {'title': 'Card 2', 'description': 'This is the description for Card 2'},
    {'title': 'Card 3', 'description': 'This is the description for Card 3'},
    {'title': 'Card 4', 'description': 'This is the description for Card 4'},
    {'title': 'Card 5', 'description': 'This is the description for Card 5'},
  ];

  CardListScreen({super.key}); // 생성자에서 super.key를 호출하여 기본 생성자를 호출합니다.

  @override
  Widget build(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;
    // 위젯의 UI를 정의하는 메서드입니다.
    return Scaffold(
      // 기본 뼈대 UI를 제공하는 Scaffold 위젯을 반환합니다.
      body: ListView.builder(
        // 스크롤 가능한 리스트를 생성하는 ListView.builder를 사용합니다.
        itemCount: items.length, // 리스트의 항목 수를 정의합니다.
        itemBuilder: (context, index) {
          // 각 항목을 생성하는 빌더 메서드입니다.
          return Card(
            // 각 항목을 카드 형태로 표시합니다.
            elevation: 0, // 카드의 그림자 깊이를 설정합니다.
            margin: EdgeInsets.all(8), // 카드 주변의 여백을 설정합니다.
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: currentTheme.primary, // 테두리 색상을 설정합니다.
                width: 2, // 테두리 두께를 설정합니다.
              ),
              borderRadius: BorderRadius.circular(8), // 카드의 모서리를 둥글게 설정합니다.
            ),
            child: Padding(
              // 카드 내부에 여백을 추가합니다.
              padding: const EdgeInsets.all(16.0), // 카드 내부의 패딩을 설정합니다.
              child: Column(
                // 카드 내부에 여러 위젯을 수직으로 배치하는 Column 위젯을 사용합니다.
                crossAxisAlignment:
                    CrossAxisAlignment.start, // 자식 위젯의 수평 정렬을 시작점으로 설정합니다.
                children: [
                  // Column의 자식 위젯 리스트를 정의합니다.
                  Text(
                    // 카드의 제목을 표시하는 Text 위젯입니다.
                    items[index]['title']!, // 현재 인덱스의 제목을 가져옵니다.
                    style: TextStyle(
                      // 텍스트 스타일을 설정합니다.
                      fontSize: 20, // 글자 크기를 설정합니다.
                      fontWeight: FontWeight.bold, // 글자를 두껍게 설정합니다.
                    ),
                  ),
                  SizedBox(height: 8), // 제목과 설명 사이의 간격을 설정합니다.
                  Text(
                    // 카드의 설명을 표시하는 Text 위젯입니다.
                    items[index]['description']!, // 현재 인덱스의 설명을 가져옵니다.
                    style: TextStyle(
                      // 텍스트 스타일을 설정합니다.
                      fontSize: 16, // 글자 크기를 설정합니다.
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
